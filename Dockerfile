FROM ubuntu:latest

ARG CRICTL_VERSION="v1.31.1"

WORKDIR /root

RUN echo 'path-exclude=/usr/share/locale/*/LC_MESSAGES/*.mo' >> /etc/dpkg/dpkg.cfg.d/excludes
RUN echo 'path-exclude=/usr/share/doc/*' >> /etc/dpkg/dpkg.cfg.d/excludes
RUN echo 'path-include=/usr/share/doc/*/copyright' >> /etc/dpkg/dpkg.cfg.d/excludes
RUN echo 'path-include=/usr/share/doc/*/changelog.Debian.*' >> /etc/dpkg/dpkg.cfg.d/excludes

#mongosh preparation
RUN wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | tee /etc/apt/trusted.gpg.d/server-8.0.asc

RUN apt-get update -qq && \
    apt-get install -y apt-transport-https \
                       ca-certificates \
                       python3 python3-pip \
                       httping \
                       man \
                       man-db \
                       vim \
                       screen \
                       curl \
                       gnupg \
                       htop \
                       dstat \
                       jq \
                       dnsutils \
                       tcpdump \
                       traceroute \
                       iputils-ping \
                       iptables \
                       net-tools \
                       ncat \
                       iproute2 \
                       strace \
                       telnet \
                       openssl \
                       psmisc \
                       dsniff \
                       wget \
                       unzip \
                       nginx

#mongosh preparation
RUN wget -qO- https://www.mongodb.org/static/pgp/server-8.0.asc | tee /etc/apt/trusted.gpg.d/server-8.0.asc
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list
RUN apt-get update -qq && \
    apt-get install -y mongodb-mongosh

#Start basic nginx page on port 80
#EXPOSE 80
#CMD nginx

# Install crictl
RUN wget https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz && \
    tar zxvf crictl-${CRICTL_VERSION}-linux-amd64.tar.gz -C /usr/local/bin && \
    rm -f crictl-${CRICTL_VERSION}-linux-amd64.tar.gz

# Specify the default image endpoint for crictl
RUN echo 'runtime-endpoint: unix:///run/containerd/containerd.sock' >> /etc/crictl.yaml
RUN echo 'image-endpoint: unix:///run/containerd/containerd.sock' >> /etc/crictl.yaml
RUN echo 'timeout: 2' >> /etc/crictl.yaml

#awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf aws*



#azure cli
#RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

CMD [ "/bin/bash" ]
