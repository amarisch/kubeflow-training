FROM python

# create data mount folder
RUN mkdir -p /data
# create work directory folder
RUN mkdir -p /workdir
RUN chmod ugo+w /data
RUN chmod ugo+w /workdir

COPY requirements.txt /workdir/requirements.txt
RUN pip install -r /workdir/requirements.txt

COPY *.py /workdir/

# sets where the default dir for when the container starts
WORKDIR /workdir