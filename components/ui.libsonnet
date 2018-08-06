{
  all(params, env):: [
    $.parts(params, env).service,
    $.parts(params, env).deployment,
  ],

  parts(params, env):: {
    // Define some defaults.
    local updatedParams = {
      serviceType: "ClusterIP",
      image: "ysunglai/demo_test_ui:0.1",
      modelUrl: "http://issue-summarization.kubeflow.svc.cluster.local:8000/api/v0.1/predictions",
    } + params,

    service:: {
      apiVersion: "v1",
      kind: "Service",
      metadata: {
        name: "issue-demo-ui",
        namespace: env.namespace,
        annotations: {
          "getambassador.io/config": "---\napiVersion: ambassador/v0\nkind:  Mapping\nname:  issue_summarization_ui\nprefix: /issue-summarization/\nrewrite: /\nservice: issue-summarization-ui:80\n",
        },
      },
      spec: {
        ports: [
          {
            port: 80,
            targetPort: 80,
          },
        ],
        selector: {
          app: "issue-demo-ui",
        },
        type: updatedParams.serviceType,
      },
    },

    deployment:: {
      apiVersion: "apps/v1beta1",
      kind: "Deployment",
      metadata: {
        name: "issue-demo-ui",
        namespace: env.namespace,
      },
      spec: {
        replicas: 1,
        template: {
          metadata: {
            labels: {
              app: "issue-demo-ui",
            },
          },
          spec: {
            containers: [
              {
                args: [
                  "app.py",
                  "--model_url",
                  updatedParams.modelUrl,
                ],
                command: [
                  "python",
                ],
                image: updatedParams.image,
		env: [
		{
		  name: "GITHUB_TOKEN",
		  value: updatedParams.githubToken,
		}
		],
                name: "issue-demo-ui",
                ports: [
                  {
                    containerPort: 80,
                  },
                ],
              },
            ],
          },
        },
      },
    }, // deployment
  }, // parts
}
