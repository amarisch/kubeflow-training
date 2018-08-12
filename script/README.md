# SCRIPT ROLUE

## Step 1
The step is independent, and you can directly execute in your new folder.
(recommendation) you don't have to git clone https://github.com/amarisch/kubeflow-training.git, only download the 1_set_kubeflow.sh.

### Reminder
* You can directly run the 1_set_kubeflow.sh. However, if you run into API rate limiting errors, ensure you have a ${GITHUB_TOKEN} environment variable set.
  Go to https://github.com/settings/tokens and generate a new token.
  and export GITHUB_TOKEN=<token>.
* Afterwards, you can execute scripts in the script folder
 
## Step 2
In this step, you should check your mount file path, or you will encounter something error.
 
## Step 3
* when you push images to your docker hub, you should log in your docker hub first.
* (Optional)You can cahange kubeflow params after executing set_training.sh. However, you can adjust the parameters to fit your environment.

## Step 4
* After you finsh the tf training, you need to enter your mount file, and wrap them to a image.
```
     docker run --rm -v $(pwd):/my_model ysunglai/service:1.0 /my_model predict 0.1 ysunglai --base-image=python:3.6 
```

## Step 5 && Step 6
Let's serving.

Step 5.
Seldon Core uses ambassador to route it's requests. To send requests to the model, you can port-forward the ambassador container locally:

```
     kubectl port-forward $(kubectl get pods -n ${NAMESPACE} -l service=ambassador -o jsonpath='{.items[0].metadata.name}') -n ${NAMESPACE} 8080:80
```

```
     curl -X POST -H 'Content-Type: application/json' -d '{"data":{"ndarray":[["issue overview add a new property to disable detection of image stream files those ended with -is.yml from target directory. expected behaviour by default cube should not process image stream files if user does not set it. current behaviour cube always try to execute -is.yml files which can cause some problems in most of cases, for example if you are using kuberentes instead of openshift or if you use together fabric8 maven plugin with cube"]]}}' http://localhost:8080/seldon/issue-summarization/api/v0.1/predictions
```

Step 6.
We use ambassador to route requests to the frontend. You can port-forward the ambassador container locally:

```
   kubectl port-forward $(kubectl get pods -n ${NAMESPACE} -l service=ambassador -o jsonpath='{.items[0].metadata.name}') -n ${NAMESPACE} 8080:80
```

