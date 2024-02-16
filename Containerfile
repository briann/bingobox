FROM quay.io/toolbx/arch-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="bingo's distrobox" \
      maintainer="brian@bngo.dev"

COPY ./arch-packages /tmp
RUN pacman -Syu --needed --noconfirm - < /tmp/arch-packages
RUN yes | pacman -Scc

RUN mkdir -p /tmp/yay-build
RUN useradd -m -G wheel builder && passwd -d builder
RUN chown -R builder:builder /tmp/yay-build
RUN su - builder -c "git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-build/yay-bin && \
    cd /tmp/yay-build/yay-bin && \
    makepkg -si --noconfirm"

# Use and configure bash, retrieve bash-prexec
RUN curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o /tmp/bash-prexec && \
    mkdir -p /usr/share/ && \
    cp /tmp/bash-prexec /usr/share/bash-prexec

# Cleanup
RUN rm -rf /tmp/*
