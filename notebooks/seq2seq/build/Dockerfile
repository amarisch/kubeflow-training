FROM python:3.6

# create data mount folder
RUN mkdir -p /data
# create work directory folder
RUN mkdir -p /workdir
RUN chmod ugo+w /data
RUN chmod ugo+w /workdir
#RUN apt-get install python-pip python-dev python-virtualenv
#RUN pip install -U pip
#RUN virtualenv --system-site-packages venv
#RUN source ~/tensorflow/venv/bin/activate
#RUN source ~/tensorflow/venv/bin/activate.csh
#RUN . ~/tensorflow/venv/bin/activate.fish
#RUN pip install -U pip

COPY requirements.txt /workdir/requirements.txt
RUN pip3 install -r /workdir/requirements.txt

COPY *.py /workdir/

# sets where the default dir for when the container starts
WORKDIR /workdir