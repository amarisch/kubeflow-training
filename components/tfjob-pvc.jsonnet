// Train the model reading & writing the data from a PVC.
local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components["tfjob-pvc"];
local k = import "k.libsonnet";

local tfjob = {
    apiVersion: "kubeflow.org/v1alpha1",
    kind: "TFJob",
    metadata: {
      name: "tf-job-issue-demo-pvc",
      namespace: env.namespace,
    },
    spec: {
      replicaSpecs: [
        {
          replicas: 1,
          template: {
            spec: {
              containers: [
                {
                  image: params.image,
                  name: "tensorflow",
                  imagePullPolicy: "IfNotPresent",
                  volumeMounts: [
                    {
                      name: "data",
                      mountPath: "/demo",                    
                    },
                  ],
                  command: [
                    "python",
                    "train.py",
                    "--sample_size=" + std.toString(params.sample_size),
                    "--input_data=" + params.input_data,
                    "--output_model=/demo/model.h5",
		    "--output_body_preprocessor_dpkl=/demo/body_preprocessor.dpkl",
		    "--output_title_preprocessor_dpkl=/demo/title_preprocessor.dpkl",                    
                  ],
                },
              ],
              volumes: [
                    {
		            name: "data",
		            persistentVolumeClaim: {
		              claimName: params.pvcName,
		            },
		          },
              ],
              restartPolicy: "OnFailure",
            },
          },
          tfReplicaType: "MASTER",
        },
      ],
      terminationPolicy: {
        chief: {
          replicaIndex: 0,
          replicaName: "MASTER",
        },
      },
    },
  };

std.prune(k.core.v1.list.new([tfjob]))
