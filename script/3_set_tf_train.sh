#!/bin/bash


KF_ENV=default

cd ../
echo "please check out you are model exist"

rm -rf /notebooks/seq2seq/build/
#make the image
#docker run -v ${pwd}/notebooks/seq2seq:/data amarischen/training-wrapper:1.0 seq2seq 1.0 amarischen ~/kubeflow-training data-pvc github_issues.csv 20000
docker run -v $(pwd)/notebooks/seq2seq:/data ysunglai/demo:latest  demo 5.0 ysunglai ./ data-pvc github_issues.csv 2000


#cd $(pwd)/notebooks/seq2seq/bulid

sh $(pwd)/notebooks/seq2seq/build/build_image.sh
sh $(pwd)/notebooks/seq2seq/build/push_image.sh

cd ../

ks apply ${KF_ENV} -c tfjob-pvc
sh $(pwd)/kubeflow-training/notebooks/seq2seq/build/set_training.sh
echo "You can use kubectl get pods -n kubeflow to see the job running"

