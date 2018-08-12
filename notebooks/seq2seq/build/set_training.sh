cd ./ && ks param set tfjob-pvc image ysunglai/demo-training:4.0 && \
ks param set tfjob-pvc input_data /data/github_issues.csv &&\
ks param set tfjob-pvc output_model /data/model.h5 &&\
ks param set tfjob-pvc sample_size 2000