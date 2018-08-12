#!/bin/bash

# Setup a shared persistent disk
KF_ENV=default

#PROJECT=${KF_DEV_PROJECT}
#ZONE=${KF_DEV_ZONE}
#NAMESPACE=${KF_DEV_NAMESPACE}
#KF_ENV=cloud
#PD_DISK_NAME=github-issues-data-${NAMESPACE}

# Create the disk
#gcloud --project=${PROJECT} compute disks create  --zone=${ZONE} ${PD_DISK_NAME} --description="PD for storing GitHub Issue data." --size=10GB

# Configure the environment to use the disk
#cd ks-kubeflow
#ks param set --env=${KF_ENV} kubeflow-core disks ${PD_DISK_NAME}
#ks apply ${KF_ENV}

# Recreate the tf-hub pod so that it picks up the disk config
#kubectl delete pod tf-hub-0 --namespace=${NAMESPACE}

cd ../../

echo "please check out your mount path"
#create pv and pvc
ks apply ${KF_ENV} -c data-pv
ks apply ${KF_ENV} -c data-pvc
ks apply ${KF_ENV} -c data-downloader
echo "You can use kubectl get pods -n kubeflow to check download"
