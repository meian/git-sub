# ツール類の取得
FROM alpine:3.22.0 AS tool-builder

RUN apk add --no-cache curl tar
RUN mkdir -p /tmp/ulb
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz
RUN tar zxf ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz
RUN mv ripgrep-14.1.0-x86_64-unknown-linux-musl/rg /tmp/ulb

# devcontainerのイメージ
FROM mcr.microsoft.com/devcontainers/base:bookworm

ARG USERNAME

RUN apt-get update \
    && apt-get install -y \
    curl \
    fzf \
    vim \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/ \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

COPY --from=tool-builder /tmp/ulb /usr/local/bin

RUN curl -sL install.mob.sh | sudo sh

RUN if [ -z "${USERNAME}" ] ; then exit 1 ; fi \
    && useradd -u1000 -g1000 -s/bin/bash -b/home/${USERNAME} ${USERNAME} 2> /dev/null || true

RUN install -d -m 0755 -o ${USERNAME} -g ${USERNAME} /workspaces

USER ${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} resources/.vimrc /home/${USERNAME}

RUN mkdir -p /home/${USERNAME}/.bin \
    && echo 'export PATH=$PATH:/home/'${USERNAME}'/.bin' >> /home/${USERNAME}/.bashrc
