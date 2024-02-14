FROM cgr.dev/chainguard/wolfi-base:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="bingo's distrobox" \
      maintainer="brian@bngo.dev"

RUN apk update && apk upgrade

# Add optional packages
COPY ./apk-packages /tmp
RUN grep -v '^#' /tmp/apk-packages | xargs apk add

# Get Distrobox-host-exec and host-spawn
RUN git clone https://github.com/89luca89/distrobox.git --single-branch /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    cp /tmp/distrobox/distrobox-export /usr/bin/distrobox-export && \
    cp /tmp/distrobox/distrobox-init /usr/bin/entrypoint && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat /tmp/distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf /tmp/distrobox && \
    ln -fs /bin/sh /usr/bin/sh

# Make some symlinks
RUN mkdir -p /usr/local/bin  && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \ 
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree

# Change root shell to BASH
RUN sed -i -e '/^root/s/\/bin\/ash/\/bin\/bash/' /etc/passwd

# Setup su-exec and fake sudo
RUN [ -e /sbin/su-exec ] && \
    chmod u+s /sbin/su-exec && \
    [ ! -e /usr/bin/sudo ] && \
    printf "%s\n%s" '#!/bin/sh' '/sbin/su-exec root "$@"' > /usr/bin/sudo && \
    chmod +x /usr/bin/sudo && \
    rm -rf /tmp/*