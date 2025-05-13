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
    qemu-utils \
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

# Create necessary directories for libvirt and qemu
RUN mkdir -p /var/lib/libvirt/images/

# Create VM disk image (after directory exists)
RUN qemu-img create -f qcow2 /var/lib/libvirt/images/vm-disk.qcow2 20G

# Rest of your Dockerfile continues...
