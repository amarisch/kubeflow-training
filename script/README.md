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
