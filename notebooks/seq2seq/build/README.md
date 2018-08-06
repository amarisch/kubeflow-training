Training: demo

This microservice was wrapped using the Seldon Core Wrappers.

Wrapping Parameters:
 - docker_image_name: demo-training
 - docker_repo: ysunglai
 - pvc_name: data-pvc
 - ksonnet_folder: ./
 - sample_size: 2000
 - docker_image_version: 4.0
 - input_data: github_issues.csv
 - model_name: demo
 - train_folder: /data
