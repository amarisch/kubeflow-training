import os
import shutil
import argparse
import jinja2

def populate_template(filename,build_folder,**kwargs):
    with open("./{}.tmp".format(filename),'r') as ftmp:
        with open("{}/{}".format(build_folder,filename),'w') as fout:
            fout.write(jinja2.Template(ftmp.read()).render(kwargs=kwargs,**kwargs))

def wrap_model(
        model_folder,
        build_folder,
        force_erase=False,
        **wrapping_arguments):
    if os.path.isdir(build_folder):
        if not force_erase:
            print("Build folder already exists. To force erase, use --force argument")
            exit(0)
        else:
            shutil.rmtree(build_folder)
    
    shutil.copytree(model_folder,build_folder)
    shutil.copy2("./Makefile",build_folder)

    populate_template(
        'Dockerfile',
        build_folder,
        **wrapping_arguments)
    populate_template(
        "build_image.sh",
        build_folder,
        **wrapping_arguments)
    populate_template(
        "push_image.sh",
        build_folder,
        **wrapping_arguments)
    populate_template(
        "set_training.sh",
        build_folder,
        **wrapping_arguments)
    populate_template(
        "README.md",
        build_folder,
        **wrapping_arguments)
     
    # Make the files executable
    st = os.stat(build_folder+"/build_image.sh")
    os.chmod(build_folder+"/build_image.sh", st.st_mode | 0111)
    st = os.stat(build_folder+"/push_image.sh")
    os.chmod(build_folder+"/push_image.sh", st.st_mode | 0111)
    st = os.stat(build_folder+"/set_training.sh")
    os.chmod(build_folder+"/set_training.sh", st.st_mode | 0111)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Utility script to wrap a python model into a docker build. The scipt will generate build folder that contains a Makefile that can be used to build and publish a Docker Image.")
    
    #parser.add_argument("data_url", type=str, help="URL of data to be downloaded")
    parser.add_argument("model_folder", type=str, help="model_folder must contain train.py and requirements.txt, and any other files used by train.py")
    parser.add_argument("model_name", type=str, help="Name of the model class and model file without the .py extension")
    parser.add_argument("version", type=str, help="Version string that will be given to the model docker image")
    parser.add_argument("repo", type=str, help="Name of the docker repository to publish the image on")
    parser.add_argument("ksonnet_folder", type=str, help="Absolute path of ksonnet folder")
    parser.add_argument("pvc_name", type=str, help="PVC name. Assume PV and PVC have been set up")
    parser.add_argument("input_data", type=str, help="Data file/folder name to be read by train.py")
    parser.add_argument("sample_size", type=int, help="training sample size")
#parser.add_argument("--base-image", type=str, default="python:2", help="The base docker image to inherit from. Defaults to python:2. Caution: this must be a debian based image.")
    parser.add_argument("--out-folder", type=str, default=None, help="Path to the folder where the build folder containing the pre-wrapped model will be created. Defaults to the model directory.")
    parser.add_argument("-f", "--force", action="store_true", help="When this flag is present the script will overwrite the contents of the output folder even if it already exists. By default the script would abort.")
    parser.add_argument("--image-name",type=str, default=None,help="Name to give to the model's docker image. Defaults to model_name-training.")

    args = parser.parse_args()
    if args.out_folder is None:
        args.out_folder = args.model_folder
    if args.image_name is None:
        args.image_name = args.model_name.lower() + "-training"

    model_folder = args.model_folder

    wrap_model(
        model_folder,
        args.out_folder+"/build",
        pvc_name = args.pvc_name,
        force_erase = args.force,
        docker_repo = args.repo,
        model_name = args.model_name,
        docker_image_version = args.version,
        docker_image_name = args.image_name,
        ksonnet_folder = args.ksonnet_folder,
        train_folder = model_folder,
        input_data = args.input_data,
        sample_size = args.sample_size,)
#base_image = args.base_image,)
