"""Kubeflow training model template using local volume/data mount

Required command line parameters:
--input_data : input data path
--output_model : output model path
--sample_size : number of data samples to use for training&validation

Optional parameters:
--learning_rate

Sample usage:
python train.py --sample_size=200000 --input_data=/data/input.csv --output_model=/data/model.h5

"""
import argparse
import logging
import os
import re
import zipfile

import dill as dpickle
import numpy as np
import pandas as pd
from keras import optimizers
from keras.layers import GRU, BatchNormalization, Dense, Embedding, Input
from keras.models import Model
from sklearn.model_selection import train_test_split

from ktext.preprocess import processor
from seq2seq_utils import load_encoder_inputs, load_text_processor

def main():  # pylint: disable=too-many-statements
  # Parsing flags.
  parser = argparse.ArgumentParser()
  parser.add_argument("--sample_size", type=int, default=2000000)
  parser.add_argument("--learning_rate", default="0.001")

  parser.add_argument(
    "--input_data",
    type=str,
    default="",
    help="The input location, a local file path.")

  parser.add_argument(
    "--output_model",
    type=str,
    default="",
    help="The output location for the model, a local file path.")

#####################################################
#  Optional section, based on what your model needs
#####################################################

  parser.add_argument(
    "--output_body_preprocessor_dpkl",
    type=str,
    default="body_preprocessor.dpkl")
  parser.add_argument(
    "--output_title_preprocessor_dpkl",
    type=str,
    default="title_preprocessor.dpkl")
  parser.add_argument(
    "--output_train_title_vecs_npy", type=str, default="train_title_vecs.npy")
  parser.add_argument(
    "--output_train_body_vecs_npy", type=str, default="train_body_vecs.npy")

########################################################
#  End of optional args section
#
#  Be sure to add your args at the appropriate sections
#  of the training code
########################################################

  args = parser.parse_args()

  logging.basicConfig(
    level=logging.INFO,
    format=('%(levelname)s|%(asctime)s'
            '|%(pathname)s|%(lineno)d| %(message)s'),
    datefmt='%Y-%m-%dT%H:%M:%S',
  )
  logging.getLogger().setLevel(logging.INFO)
  logging.info(args)

  learning_rate = float(args.learning_rate)

  pd.set_option('display.max_colwidth', 500)

##################################################
#  Reading input file(s)
#  Make changes as needed
##################################################

  # Reading input data file
  ext = os.path.splitext(args.input_data)[-1]
  if ext.lower() == '.zip':
    zip_ref = zipfile.ZipFile(args.input_data, 'r')
    zip_ref.extractall('.')
    zip_ref.close()
    # TODO(jlewi): Hardcoding the file in the Archive to use is brittle.
    # We should probably just require the input to be a CSV file.
    csv_file = 'github_issues.csv'
  else:
    csv_file = args.input_data

###################################################
#  Fill in your model training code starting here
###################################################

  # Read in data sample 2M rows (for speed of tutorial)
  traindf, testdf = train_test_split(
    pd.read_csv(csv_file).sample(n=args.sample_size), test_size=.10)

  # Print stats about the shape of the data.
  logging.info('Train: %d rows %d columns', traindf.shape[0], traindf.shape[1])
  logging.info('Test: %d rows %d columns', testdf.shape[0], testdf.shape[1])

  train_body_raw = traindf.body.tolist()
  train_title_raw = traindf.issue_title.tolist()

  # Clean, tokenize, and apply padding / truncating such that each document
  # length = 70. Also, retain only the top 8,000 words in the vocabulary and set
  # the remaining words to 1 which will become common index for rare words.
  body_pp = processor(keep_n=8000, padding_maxlen=70)
  train_body_vecs = body_pp.fit_transform(train_body_raw)

  logging.info('Example original body: %s', train_body_raw[0])
  logging.info('Example body after pre-processing: %s', train_body_vecs[0])

  # Instantiate a text processor for the titles, with some different parameters.
  title_pp = processor(
    append_indicators=True, keep_n=4500, padding_maxlen=12, padding='post')

  # process the title data
  train_title_vecs = title_pp.fit_transform(train_title_raw)

  logging.info('Example original title: %s', train_title_raw[0])
  logging.info('Example title after pre-processing: %s', train_title_vecs[0])

  # Save the preprocessor.
  with open(args.output_body_preprocessor_dpkl, 'wb') as f:
    dpickle.dump(body_pp, f)

  with open(args.output_title_preprocessor_dpkl, 'wb') as f:
    dpickle.dump(title_pp, f)

  # Save the processed data.
  np.save(args.output_train_title_vecs_npy, train_title_vecs)
  np.save(args.output_train_body_vecs_npy, train_body_vecs)

  _, doc_length = load_encoder_inputs(args.output_train_body_vecs_npy)

  num_encoder_tokens, body_pp = load_text_processor(
    args.output_body_preprocessor_dpkl)
  num_decoder_tokens, title_pp = load_text_processor(
    args.output_title_preprocessor_dpkl)

  # Arbitrarly set latent dimension for embedding and hidden units
  latent_dim = 300

  ###############
  # Encoder Model.
  encoder_inputs = Input(shape=(doc_length,), name='Encoder-Input')

  # Word embeding for encoder (ex: Issue Body)
  x = Embedding(
    num_encoder_tokens, latent_dim, name='Body-Word-Embedding',
    mask_zero=False)(encoder_inputs)
  x = BatchNormalization(name='Encoder-Batchnorm-1')(x)

  # We do not need the `encoder_output` just the hidden state.
  _, state_h = GRU(latent_dim, return_state=True, name='Encoder-Last-GRU')(x)

  # Encapsulate the encoder as a separate entity so we can just
  # encode without decoding if we want to.
  encoder_model = Model(
    inputs=encoder_inputs, outputs=state_h, name='Encoder-Model')

  seq2seq_encoder_out = encoder_model(encoder_inputs)

  ################
  # Decoder Model.
  decoder_inputs = Input(
    shape=(None,), name='Decoder-Input')  # for teacher forcing

  # Word Embedding For Decoder (ex: Issue Titles)
  dec_emb = Embedding(
    num_decoder_tokens,
    latent_dim,
    name='Decoder-Word-Embedding',
    mask_zero=False)(decoder_inputs)
  dec_bn = BatchNormalization(name='Decoder-Batchnorm-1')(dec_emb)

  # Set up the decoder, using `decoder_state_input` as initial state.
  decoder_gru = GRU(
    latent_dim, return_state=True, return_sequences=True, name='Decoder-GRU')
  decoder_gru_output, _ = decoder_gru(dec_bn, initial_state=seq2seq_encoder_out)
  x = BatchNormalization(name='Decoder-Batchnorm-2')(decoder_gru_output)

  # Dense layer for prediction
  decoder_dense = Dense(
    num_decoder_tokens, activation='softmax', name='Final-Output-Dense')
  decoder_outputs = decoder_dense(x)

  ################
  # Seq2Seq Model.

  seq2seq_Model = Model([encoder_inputs, decoder_inputs], decoder_outputs)

  seq2seq_Model.compile(
    optimizer=optimizers.Nadam(lr=learning_rate),
    loss='sparse_categorical_crossentropy')

  seq2seq_Model.summary()

########################################################
#  End of your training code 
#
#  * Be sure to save your model to args.output_model
#     such as Model.save(args.output_model)
########################################################
  
  # Save model.
  seq2seq_Model.save(args.output_model)


if __name__ == '__main__':
  main()
