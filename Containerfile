FROM quay.io/toolbx/arch-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="bingo's distrobox" \
      maintainer="brian@bngo.dev"

COPY ./arch-packages /tmp
RUN pacman -Syu --needed --noconfirm - < /tmp/arch-packages
RUN rm -rf /tmp/*
RUN yes | pacman -Scc

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
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/glances && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/htop && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/op && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/tailscale && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/ujust && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/virt-top && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/wl-copy && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/wl-paste && \
    true

# Use and configure bash, retrieve bash-prexec
RUN curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o /tmp/bash-prexec && \
    mkdir -p /usr/share/ && \
    cp /tmp/bash-prexec /usr/share/bash-prexec && \
    rm -rf /tmp/*
