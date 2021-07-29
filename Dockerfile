FROM ubuntu:18.04

LABEL maintainer="jannetta.steyn@newcastle.ac.uk"
ENV TZ=Europe/London
ARG DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils
# RUN apt-get install -y jupyter jupyter-core jupyter-notebook
# RUN apt-get -y install vim python3.6 python3.6-dev python3-pip wget git apt-transport-https software-properties-common zip unzip libpaper-utils xdg-utils liblas3 libcairo2 libcurl4 libjpeg8 liblapack3 libpango-1.0-0 libpangocairo-1.0-0 libpng16-16 libtiff5 libtk8.6 libxt6 gfortran libblas-dev libatlas-base-dev liblapack-dev libatlas-base-dev libncurses5-dev libreadline-dev libjpeg-dev libpcre3-dev libpng-dev zlib1g-dev libbz2-dev liblzma-dev libicu-dev pkg-config r-base-core r-base-dev jupyter jupyter-core jupyter-notebook
RUN apt-get install -y git python3.8 python3-pip wget
ENV PATH $PATH:/usr/local/conda/bin

## Download and install required Linux packages
RUN apt-get -qq update && apt-get -qq -y install gnupg curl wget bzip2 git gcc vim unixodbc-dev python3-dev g++ postgresql-client r-base r-base-core r-base-dev sqlite \
	&& wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	&& bash Miniconda3-latest-Linux-x86_64.sh -bfp /usr/local/conda \
	&& conda install -y python=3.8 \
	&& conda update conda \
	&& apt-get -qq -y autoremove \
	&& apt-get autoclean \
	&& rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
	&& conda clean --all --yes
RUN pip install mlflow[extras]==1.13.1
RUN pip install whylogs==0.4.9
RUN pip install jupyter jupyter-core notebook
RUN mkdir /models
RUN rm /Miniconda3-latest-Linux-x86_64.sh
COPY *.sql /models/
COPY examples/ /models
COPY start.sh /start.sh
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py
# ENV MLFLOW_TRACKING_URI='sqlite:////models/mlruns.db'
ENV MLFLOW_TRACKING_URI='http://0.0.0.0:5000'
WORKDIR /models
RUN cat demo1_multiclass_create.sql | sqlite3 mlruns.db
EXPOSE 5000
EXPOSE 1230-1240
EXPOSE 8080
# CMD tail -f /dev/null
# CMD mlflow ui --backend-store-uri 'sqlite:////models/mlruns.db' -h 0.0.0.0 ; jupyter notebook --port=8080 --no-browser --ip=0.0.0.0 --allow-root
CMD ["/bin/bash", "/start.sh"]
