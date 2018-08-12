# Change to your docker repo ID
# In order to push and pull image from your docker account,
# you must have your docker ID in the image name follow by /[image name]
REPO := ysunglai

# choose the model folder
MODELFOLDER := seq2seq

# Change image name for a specific model. ex, seq2seqtraining
IMG := training

TAG := $(shell date +v%Y%m%d)

build:
    docker build -f $(MODELFOLDER)/build/Dockerfile -t $(REPO)/$(IMG) $(MODELFOLDER)/

push: build
    docker push $(REPO)/$(IMG)

# Change the cd path to where your ksonnet app.yaml is located
set-image: push
    cd ../.. && ks param set tfjob-pvc image $(REPO)/$(IMG)
