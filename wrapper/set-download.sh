cd ../.. && ks param set data-downloader dataUrl https://storage.googleapis.com/kubeflow-examples/github-issue-summarization-data/github-issues.zip && \
ks param set data-downloader dataPath /data && \
ks param set data-downloader pvcName data-pvc