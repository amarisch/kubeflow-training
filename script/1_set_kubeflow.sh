#!/bin/bash
#https://github.com/amarisch/kubeflow-training
# Instantiates a fresh version of kubeflow on a cluster
KF_DEV_NAMESPACE=kubeflow
KF_VERSION=v0.1.0
NAMESPACE=${KF_DEV_NAMESPACE}
APP_NAME=my-kubeflow
KF_ENV=default

# Initialize an empty ksonnet app
ks version
ks init ${APP_NAME}

# Install kubeflow core package
cd ${APP_NAME}
ks registry add kubeflow github.com/kubeflow/kubeflow/tree/${KF_VERSION}/kubeflow
ks pkg install kubeflow/core@${KF_VERSION}

# Generate core component
ks generate core kubeflow-core --name=kubeflow-core

# Enable anonymous usage metrics
ks param set kubeflow-core reportUsage true
ks param set kubeflow-core usageId $(uuidgen)

# Define an environment
#ks env add ${KF_ENV}

# Configure our cloud to use GCP features
#ks param set kubeflow-core cloud gke --env=${KF_ENV}

# Set Jupyter storageclass
#ks param set kubeflow-core jupyterNotebookPVCMount /home/jovyan

# Create a namespace for my deployment
kubectl create namespace ${NAMESPACE}
ks env set ${KF_ENV} --namespace ${NAMESPACE}

# Instantiate objects on the cluster
ks apply ${KF_ENV} -c kubeflow-core

#Git clone amarisch example
git clone https://github.com/amarisch/kubeflow-training.git

#copy components
cd kubeflow-training

cp -rf components/* ../components


