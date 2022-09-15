FROM debian:11-slim
LABEL maintainer="Paolo Velati"

ARG DEBIAN_FRONTEND=noninteractive

# Install pve sources
RUN apt-get update \
    && apt-get -y install curl wget git apt-utils \
    && echo 'deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription' > /etc/apt/sources.list.d/pve-no-subscription.list \
    && curl https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -o /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg \
    && git clone --depth 1 --branch pve-kernel-5.15 https://git.proxmox.com/git/pve-kernel.git

WORKDIR pve-kernel

# Install dependencies.
RUN apt-get update \
    && apt-get install -y build-essential packaging-dev debian-keyring devscripts equivs python3-dev python-is-python3 \
    && mk-build-deps --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' --install debian/control.in \
    && cd && rm -rf pve-kernel \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

CMD ["/bin/bash"]
