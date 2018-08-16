FROM markliou/younghsiung

LABEL "docker_repo"="ysunglai"
LABEL "docker_image_name"="issue-summarization"
LABEL "docker_image_version"="0.1"
LABEL "service_type"="MODEL"
LABEL "base_image"="python:3.6"
LABEL "model_name"="IssueSummarization"
LABEL "persistence"="0"
LABEL "api_type"="REST"

RUN apt-get update -y && \
    apt-get install -y python3-tk
RUN apt-get install -y python-pip python-dev build-essential

#COPY /requirements.txt /tmp/
COPY /seldon_requirements.txt /tmp/
RUN cd /tmp && \
    pip install --no-cache-dir -r seldon_requirements.txt
#    pip install --no-cache-dir -r requirements.txt

RUN mkdir microservice
COPY ./ /microservice/
WORKDIR /microservice

EXPOSE 5000
CMD ["python3","-u","microservice.py","IssueSummarization","REST","--service-type","MODEL","--persistence","0"]
