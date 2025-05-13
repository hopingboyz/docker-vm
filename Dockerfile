# Use Ubuntu with systemd as base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive \
    container=docker

# Install systemd and dependencies
RUN apt-get update && \
    apt-get install -y \
    systemd \
    systemd-sysv \
    dbus \
    wget \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    net-tools \
    qemu-system-x86 \
    spice-html5 \
    docker.io \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    && rm -f /lib/systemd/system/systemd-update-utmp*

# Enable necessary systemd services
RUN systemctl enable docker.service

# Download and configure noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
    && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify \
    && ln -s /opt/noVNC/utils/launch.sh /usr/local/bin/novnc

# Create VM disk image
RUN qemu-img create -f qcow2 /var/lib/libvirt/images/vm-disk.qcow2 20G

# Copy service files and startup scripts
COPY qemu-vm.service /etc/systemd/system/
COPY start-vm.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-vm.sh \
    && systemctl enable qemu-vm.service

# Prepare Docker-in-Docker
RUN echo 'DOCKER_OPTS="--storage-driver=overlay2"' > /etc/default/docker \
    && mkdir -p /etc/systemd/system/docker.service.d

# Expose ports
EXPOSE 6080 2375

# Set the entrypoint to init
ENTRYPOINT ["/lib/systemd/systemd"]
