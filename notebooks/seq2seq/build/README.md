Training: seq2seq

This microservice was wrapped using the Seldon Core Wrappers.

Wrapping Parameters:
 - docker_image_name: seq2seq-training
 - docker_repo: amarischen
 - pvc_name: data-pvc
 - ksonnet_folder: /home/0656072/kubeflow_Learning/my-kubeflow
 - sample_size: 20000
 - docker_image_version: 1.0
 - input_data: github_issues.csv
 - model_name: seq2seq
 - train_folder: /data
