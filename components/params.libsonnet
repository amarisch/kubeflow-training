{
  global: {
    // User-defined global parameters; accessible to all component and environments, Ex:
    // replicas: 4,
  },
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    "kubeflow-core": {
      cloud: "null",
      disks: "null",
      jupyterHubAuthenticator: "null",
      jupyterHubImage: "gcr.io/kubeflow/jupyterhub-k8s:1.0.1",
      jupyterHubServiceType: "ClusterIP",
      jupyterNotebookPVCMount: "null",
      name: "kubeflow-core",
      namespace: "null",
      reportUsage: "true",
      tfAmbassadorServiceType: "ClusterIP",
      tfDefaultImage: "null",
      tfJobImage: "gcr.io/kubeflow-images-staging/tf_operator:v20180329-a7511ff",
      tfJobUiServiceType: "ClusterIP",
      usageId: "a6fd7371-0134-4035-948d-020a096ff98f",
    },
    "tfjob-pvc": {
      image: "ysunglai/demo-training:4.0",
      input_data: "/demo/github_issues.csv",
      namespace: "kubeflow",
      output_model: "/demo/model.h5",
      output_body_preprocessor_dpkl: "/demo/body_preprocessor.dpkl",
      output_title_preprocessor_dpkl: "/demo/title_preprocessor.dpkl",
      pvcName: "data-pvc",
      sample_size: 20000,
    },
    "data-downloader": {
    },
    "data-pvc": {
    },
    "data-pv": {
    },
    "seldon": {
      apifeImage: "seldonio/apife:0.1.5",
      apifeServiceType: "NodePort",
      engineImage: "seldonio/engine:0.1.5",
      name: "seldon",
      namespace: "kubeflow",
      operatorImage: "seldonio/cluster-manager:0.1.5",
      operatorJavaOpts: "null",
      operatorSpringOpts: "null",
      withApife: "false",
      withRbac: "true",
    },
    "demo-test-serving": {
      endpoint: "REST",
      image: "amarischen/issue-summarization:0.1",
      name: "demo-serving",
      namespace: "kubeflow",
      pvcName: "null",
      replicas: 2,
    },
    "ui": {
      namespace: "null",
      githubToken: "fe5224dd3b43e991091b1e635af9a8ea0ca974f5",
      image: "ysunglai/demo_test_ui:0.1",
    },

  },
}
