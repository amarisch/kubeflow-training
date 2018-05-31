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
      jupyterNotebookPVCMount: "/home/0656072/kubeflow_Learning/my-kubeflow",
      name: "kubeflow-core",
      namespace: "null",
      reportUsage: "true",
      tfAmbassadorServiceType: "ClusterIP",
      tfDefaultImage: "null",
      tfJobImage: "gcr.io/kubeflow-images-public/tf_operator:v20180329-a7511ff",
      tfJobUiServiceType: "ClusterIP",
      usageId: "3a30d81c-032f-4e18-9957-cc228009db37",
    },
    "tfjob-pvc": {
      image: "amarischen/training2",
      pvcName: "data-pvc",
      input_data: "/data/github_issues.csv",
      namespace: "kubeflow",
      output_model: "/data/model.h5",
      sample_size: "2000000",
    },
    "data-pvc": {
    },
    "data-pv": {
    },
    "data-downloader": {
    },
  },
}
