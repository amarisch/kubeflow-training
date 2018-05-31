# kubeflow-training  
  
## Training Wrapper  
This training wrapper helps you to organize and package files for kubeflow training.  To simplify the process, I have containerized the python script.  
  
### Preparations  
* Model folder: this model folder must contain the following  
    * __train.py__  train.py takes in input data file(s) and outputs a model file (.h5 or etc). You can follow my train.py template.  
    * any files created for train.py such as a utils.py file  
    * __requirements.txt__  listing any pythin packages required by the above python files.  
  
* input data: downloaded and stored in a location accessible by the cluster.  
* PVC name: you must have created a PV and PVC with a mounted folder where your input and output files are located  
  
  
### Let's wrap it!  
  
```
docker run -v ~/kubeflow-training/notebooks/seq2seq:/data amarischen/training-wrapper:1.0 seq2seq 1.0 amarischen ~/kubeflow-training data-pvc github_issues.csv 20000

```
  
 ```
docker run amarischen/training-wrapper:1.0  
        [-h] [-f] [--image-name IMAGE_NAME]
        model_name
        version 
        repo 
        ksonnet_folder 
        pvc_name
        input_data 
        sample_size
 ```
