# kubeflow-training  
  
## Training Wrapper (for tfjob-pvc)  
This training wrapper helps you to organize and package files for kubeflow training.  To simplify the process, I have containerized the python script.  
  
### Preparations  
* Model folder: this model folder must contain the following  
    * __train.py__  train.py takes in input data file(s) and outputs a model file (.h5 or etc). You can follow my train.py template.  
    * any files created for train.py such as a utils.py file  
    * __requirements.txt__  listing any python packages required by the above python files.  
  
* input data: downloaded and stored in a location accessible by the cluster.  
* PVC name: you must have created a PV and PVC with a mounted folder where your input and output files are located  
  
  
### Let's wrap it!  
  
```
docker run -v ~/kubeflow-training/notebooks/seq2seq:/data amarischen/training-wrapper:1.0 seq2seq 1.0 amarischen ~/kubeflow-training data-pvc github_issues.csv 20000
```
  
`docker run amarischen/training-wrapper:1.0`: run training wrapper container  
`-v ~/kubeflow-training/notebooks/seq2seq:/data`: tells docker to mount your local folder to /data in the container. This is used to access your files and generate the wrapped model files. I have preset the folder destination in the container to /data, so you simply have to set your local model folder path  

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
Required:  
* model_name: the name of your model  
* version: model version  
* repo: the name of your docker repository, where the training image will be stored  
* ksonnet_folder: path to your ksonnet folder where app.yaml and components/ folder is located  
* pvc_name: the name of your PVC  
* input_data: file name/folder name of your training data  
* sample_data: training data size  
  
Optional:  
* out-folder: The folder that will be created to contain the output files. Defaults to [path to your local model folder]/build  
* force: When this flag is present, the build folder will be overwritten if it already exists. The wrapping is aborted by default  
  
You can use the python script locally by running `wrap_training.py`.  
  
### Build and push the Docker image  
A `build` folder should now appear in your model folder. cd into it and do the following:  
```
./build_image.sh
./push_image.sh
```
### Set tfjob  
Finally set the parameters of your kubeflow tfjob  
```
./set_training.sh
```
If you type `ks param list` from your ksonnet folder, you should see new params added to tfjob-pvc  

### Deploy training  
You can now deploy your training job by running:
```
cd /path/to/ksonnet/folder
ks apply [env] -c tfjob-pvc
```
The resulting trained model file will be outputed to the disk from which you mounted your PV

### Serving model
We use seldon-serve-simple-v1alpha1 to serve our runtime model. If you want to use seldon-serve-simple-v1alpha2, you need to set the seldonVersion parameter to one in the 0.2.x range.

