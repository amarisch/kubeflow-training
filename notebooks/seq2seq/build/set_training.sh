cd /home/0656072/kubeflow_Learning/my-kubeflow && ks param set tfjob-pvc image amarischen/seq2seq-training:1.0 && \
ks param set tfjob-pvc input_data /data/github_issues.csv &&\
ks param set tfjob-pvc output_model /data/model.h5 &&\
ks param set tfjob-pvc sample_size 20000