FROM ubuntu:20.04

LABEL maintainer="jannetta.steyn@newcastle.ac.uk"
ENV TZ=Europe/London
ARG DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y git python3.8 python3-pip wget
ENV PATH $PATH:/usr/local/conda/bin

## Download and install required Linux packages
RUN apt-get -qq update && apt-get -qq -y install gnupg curl wget bzip2 git gcc vim unixodbc-dev python3-dev g++ postgresql-client r-base r-base-core r-base-dev sqlite \
	&& wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	&& bash Miniconda3-latest-Linux-x86_64.sh -bfp /usr/local/conda \
	&& conda install -y python=3 \
	&& conda update conda \
	&& apt-get -qq -y autoremove \
	&& apt-get autoclean \
	&& rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
	&& conda clean --all --yes
RUN rm /Miniconda3-latest-Linux-x86_64.sh

## Download and install Python packages
RUN pip install mlflow[extras]==1.13.1
RUN pip install whylogs==0.4.9
RUN pip install jupyter jupyter-core notebook


RUN mkdir /models
COPY *.sql /models/
COPY examples/ /models
COPY start.sh /start.sh
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
ENV MLFLOW_TRACKING_URI='http://0.0.0.0:5000'
WORKDIR /models
RUN cat demo1_multiclass_create.sql | sqlite3 mlruns.db
EXPOSE 5000
EXPOSE 1230-1240
EXPOSE 8080
# CMD tail -f /dev/null
CMD ["/bin/bash", "/start.sh"]
