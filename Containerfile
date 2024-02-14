FROM quay.io/toolbx-images/ubuntu-toolbox:23.10

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="bingo's distrobox" \
      maintainer="brian@bngo.dev"

COPY extra-packages /
RUN apt-get update && \ 
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
        $(cat /extra-packages | xargs) && \
    rm -rd /var/lib/apt/lists/*

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree

RUN echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers