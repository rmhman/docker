FROM ubuntu:20.04
RUN apt -y update && apt -y upgrade
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
RUN apt-get install -y tzdata
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip
RUN apt -y install \
  apt-transport-https \
  gnupg \
  sudo \
  wget
RUN ["/bin/bash", "-c", "set -o pipefail && wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -"]
RUN ["/bin/bash", "-c", "set -o pipefail && echo \"deb https://packages.cloudfoundry.org/debian stable main\" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list"]

RUN apt -y update && apt -y install \
  bc \
  netcat \
  cf7-cli \
  curl \
  default-jdk \
  dnsutils \
  git \
  iputils-ping \
  jq \
  redis-tools \
  unzip \
  ansible \
  vim
################################
# Install Terraform
################################

# Download terraform for linux
RUN wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip

# Unzip
RUN unzip terraform_1.0.11_linux_amd64.zip

# Move to local bin
RUN mv terraform /usr/local/bin/
# Check that it's installed
RUN terraform --version 

################################
# Install AWS CLI
################################
RUN pip install awscli --upgrade --user

# add aws cli location to path
ENV PATH=~/.local/bin:$PATH

RUN mkdir ~/.aws && touch ~/.aws/credentials

RUN pip install --upgrade pip
RUN cf --version
RUN git --version
RUN java -version
RUN pip --version
RUN useradd -ms /bin/bash ubuntu
RUN usermod -aG sudo ubuntu
RUN passwd -d ubuntu
RUN echo "***** Switching to ubuntu user *****"
USER ubuntu
WORKDIR /home/ubuntu
ENV HOME /home/ubuntu
ENV PATH /home/ubuntu/.local/bin:$PATH
RUN pip install --upgrade --user awscli
RUN mkdir .ssh
RUN chmod 700 .ssh
COPY ./to_copy/ssh_config .ssh/config
COPY ./to_copy/enron_git_clone .
COPY ./to_copy/bash_profile .bash_profile
RUN sudo chown -R ubuntu:ubuntu .
RUN echo "***** COMPLETE *****"
