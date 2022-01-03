FROM ubuntu:latest

LABEL "com.github.actions.name"="Github Action for download"
LABEL "com.github.actions.description"="Github Action for download"
LABEL "com.github.actions.icon"="download"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="http://github.com/iamazy/download-action"
LABEL "homepage"="http://github.com/iamazy/download-action"
LABEL "maintainer"="iamazy <iamazy.me@outlook.com>"

ARG GO_PKG=go.tar.gz
ARG WORKSPACE=/home/download/

RUN  apt-get update \
  && apt-get install -y git \
  && apt-get install -y zip unzip \
  && apt-get install -y wget \
  && apt-get install -y build-essential \
  && rm -rf /var/lib/apt/lists/*
RUN wget 'https://golang.google.cn/dl/go1.17.5.linux-amd64.tar.gz' -O ${GO_PKG}
RUN tar -C /usr/local/ -zxf ${GO_PKG}
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin
RUN rm -rf ${GO_PKG}
RUN go install github.com/anacrolix/torrent/cmd/...@latest
RUN mkdir -p ${WORKSPACE}
WORKDIR ${WORKSPACE}

# alpine image has no /lib64/ld-linux-x86-64.so.2
# RUN mkdir /lib64
# RUN ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
# RUN apk add --no-cache ca-certificates

# torrent download 'magnet:?xt=urn:btih:KRWPCX3SJUM4IMM4YF5RPHL6ANPYTQPU'

ADD *.sh /

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]