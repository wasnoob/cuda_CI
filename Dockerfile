FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ARG user=uework
ARG pwd=uework@2022
ARG condapath=/home/miniconda
#images info
LABEL version="1.0"
LABEL org.opencontainers.image.description 'base on nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04'

#安装依赖
RUN  apt-get update && apt-get install -y sudo

#添加用户 赋予sudo权限 指定密码
RUN useradd --create-home --no-log-init --shell /bin/bash ${user} \
    && adduser ${user} sudo \
    && echo "${user}:${pwd}" | chpasswd

# 指定容器起来的工作目录
WORKDIR /home/${user}

#复制本地template下的文件到目标根目录
ADD . /home/uework

# 指定容器起来的登录用户
USER ${user}

#安装miniconda && ssh
RUN echo ${pwd}|sudo -S apt-get update && echo ${pwd}|sudo -S apt-get install openssh-server -y
RUN cd /home  && set -e 
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh  -O ~/miniconda.sh
RUN echo ${pwd}|sudo -S bash ~/miniconda.sh -b -p /home/miniconda 
RUN ${condapath}/bin/conda init $(echo $SHELL | awk -F '/' '{print $NF}') 
RUN echo 'Successfully installed miniconda...' && echo -n 'Conda version: ' 
RUN ${condapath}/bin/conda --version && echo -e '\n' 

#安装pytorch，tensorflow-gpu jupyter
#Run echo ${pwd}|sudo -S ${condapath}/bin/conda install -y pytorch=1.12.1 tensorflow-gpu gradio cv2 diffusers=0.9.0 numpy PIL random torchvision=0.13.1 pytorch-lightning=1.5.9
#Run echo ${pwd}|sudo -S ${condapath}/bin/conda install -y pytorch==1.12.1 && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y torchvision==0.13.1 && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y torchaudio==0.12.1 && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y cudatoolkit=11.3 && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y pytorch-lightning=1.5.9 
#Run echo ${pwd}|sudo -S ${condapath}/bin/conda install -y cv2 && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y gradio && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y diffusers=0.9.0 && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y numpy && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y PIL && echo ${pwd}|sudo -S ${condapath}/bin/conda install -y random 
 
Run echo ${pwd}|sudo -S ${condapath}/bin/conda install -y pytorch==1.12.1 -c pytorch \
echo ${pwd}|sudo -S ${condapath}/bin/conda install -y torchvision==0.13.1 -c pytorch\
echo ${pwd}|sudo -S ${condapath}/bin/conda install -y torchaudio==0.12.1 -c pytorch\
echo ${pwd}|sudo -S ${condapath}/bin/conda install -y cudatoolkit=11.3 -c pytorch   
Run echo ${pwd}|sudo -S ${condapath}/bin/conda install -y cv2\
echo ${pwd}|sudo -S ${condapath}/bin/conda install -y gradio\
echo ${pwd}|sudo -S ${condapath}/bin/conda install -y diffusers=0.9.0\
echo ${pwd}|sudo -S ${condapath}/bin/conda install -y numpy \
echo ${pwd}|sudo -S ${condapath}/bin/conda install -y PIL \
echo ${pwd}|sudo -S ${condapath}/bin/conda install -y random
 
RUN exec bash
