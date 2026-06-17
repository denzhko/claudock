FROM ubuntu:jammy

RUN apt-get update \
    && apt-get install -y sudo curl locales

# Setup locales
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Create user
ARG USER
ARG USER_UID
ARG USER_GID
RUN groupadd -f -g ${USER_GID} ${USER} \
    && useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Docker CLI
ARG DOCKER_GID
RUN groupadd -g ${DOCKER_GID} docker \
    && apt-get update \
    && apt-get install -y docker.io docker-compose \
    && sudo usermod -aG docker ${USER}

USER ${USER}
WORKDIR /home/${USER}/workspace

# Install Claude Code
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY
ENV HTTP_PROXY=${HTTP_PROXY} \
    HTTPS_PROXY=${HTTPS_PROXY} \
    NO_PROXY=${NO_PROXY} \
    CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
    PATH=$PATH:~/.local/bin
RUN curl -fsSL https://claude.ai/install.sh | bash

# Install Go
ARG GO_VERSION=1.26.4
ARG ARCH=arm64
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz | sudo tar -C /usr/local -xz
ENV PATH=$PATH:/usr/local/go/bin

# Install bash completion
RUN sudo apt-get update \
    && sudo apt-get install -y bash-completion \
    && echo 'source /usr/share/bash-completion/bash_completion' >> ~/.bashrc

# Install packages for development
RUN sudo apt-get update \
    && sudo apt-get install -y \
        build-essential \
        git \
        ranger \
        tmux \
        vim
