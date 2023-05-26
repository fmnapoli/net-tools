FROM python:3.11-alpine AS builder

ENV AWSCLI_VERSION=2.11.22

RUN apk add --no-cache \
    curl \
    bash \
    make \
    cmake \
    gcc \
    g++ \
    libc-dev \
    libffi-dev \
    openssl-dev \
    && curl https://awscli.amazonaws.com/awscli-$AWSCLI_VERSION.tar.gz | tar -xz \
    && cd awscli-$AWSCLI_VERSION \
    && ./configure --prefix=/opt/aws-cli/ --with-download-deps \
    && make \
    && make install

RUN curl -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=/opt --disable-prompts

FROM alpine:3.18

RUN apk update && \
    apk upgrade && \
    apk --no-cache add \
    bash \
    bind-tools \
    curl \
    groff \
    iputils \
    jq \
    nano \
    net-tools \
    netcat-openbsd \
    nmap \  
    nmap-ncat \ 
    nmap-scripts \ 
    openssh-client \
    openssl \
    postgresql-client \
    python3 \
    py3-pip \
    speedtest-cli \
    sshfs \
    tcpdump \
    which \
    elinks \
    && rm -rf /var/cache/apk/*

    COPY --from=builder /opt/ /opt/
    COPY scripts/ /usr/local/bin/

    RUN chmod +x /usr/local/bin/*

    ENV PATH $PATH:/opt/aws-cli/bin:/opt/google-cloud-sdk/bin

    CMD ["/bin/bash"]
