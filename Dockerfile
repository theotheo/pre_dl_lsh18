FROM python:3-stretch

MAINTAINER i <ibelyalov@yandex.ru>

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt install nodejs
RUN npm install -g configurable-http-proxy
RUN apt update && apt install -y libgl1-mesa-glx
RUN pip install PyQt5

RUN pip install Pillow numpy tensorflow==1.5 keras googletrans matplotlib
RUN python3 -c "from keras.applications.resnet50 import ResNet50; ResNet50(weights='imagenet')"
RUN python3 -c "from keras.utils.data_utils import get_file; get_file('imagenet_class_index.json', 'https://s3.amazonaws.com/deep-learning-models/image-models/imagenet_class_index.json')"

RUN pip install notebook
RUN pip install jupyterhub
RUN pip install nbgrader
RUN pip install git+https://github.com/jupyterhub/oauthenticator.git
RUN pip install tornado==4.4 # workaround 
RUN pip install sklearn


RUN pip install ipywidgets
RUN jupyter nbextension enable --sys-prefix --py widgetsnbextension

RUN pip install ipympl==0.1.0
RUN jupyter nbextension enable --py --sys-prefix ipympl 

RUN pip install fileupload
RUN jupyter nbextension install --sys-prefix --py fileupload
RUN jupyter nbextension enable --sys-prefix --py fileupload

RUN jupyter nbextension install --sys-prefix --py nbgrader --overwrite
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader
RUN jupyter nbextension disable --sys-prefix create_assignment/main
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader



RUN mkdir -p /hub/home/theotheo
RUN useradd theotheo -b /hub/home
RUN chown theotheo /hub/home/theotheo


USER theotheo
RUN jupyter nbextension enable --user create_assignment/main
RUN jupyter nbextension enable --user formgrader/main --section=tree
RUN jupyter serverextension enable --user nbgrader.server_extensions.formgrader

USER root

ARG CACHEBUST=1
RUN pip install -U teacher_nbextension
RUN jupyter nbextension install teacher_nbextension --py --sys-prefix 
RUN jupyter nbextension enable --py --sys-prefix  teacher_nbextension 
RUN jupyter serverextension enable --py --sys-prefix teacher_nbextension 

ADD jupyterhub_config.py jupyterhub_config.py
ADD nbgrader_config.py /etc/jupyter/nbgrader_config.py
ADD userlist userlist

RUN mkdir -p /hub/exchange
RUN chmod ugo+rw /hub/exchange

VOLUME /hub

ADD logo.png logo.png

EXPOSE 10000
