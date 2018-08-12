#!/bin/bash

# Build and deploy a UI for accessing the trained model

#Go to https://github.com/settings/tokens and generate a new token.
GITHUB_TOKEN=e52faae4b90767b2fef253b59778f9c4ddf07460
NAMESPACE=kubeflow
KF_ENV=default

# Create the image locally
cd ../docker
docker build -t ysunglai/demo_serving_ui:0.1 .

# Store in the container repo
docker push  ysunglai/demo_serving_ui:0.1

cd ../../

ks param set ui github_token ${GITHUB_TOKEN} --env ${KF_ENV}
ks apply ${KF_ENV} -c ui

# Open access outside the cluster
kubectl port-forward $(kubectl get pods -n ${NAMESPACE} -l service=ambassador -o jsonpath='{.items[0].metadata.name}') -n ${NAMESPACE} 8080:80
