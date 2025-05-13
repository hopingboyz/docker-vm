#!/bin/bash

# Start Xvfb
Xvfb :1 -screen 0 1024x768x16 &> /dev/null &
export DISPLAY=:1

# Start Docker daemon
dockerd &> /var/log/docker.log &

# Start QEMU with KVM and VNC
qemu-system-x86_64 \
    -hda /var/lib/libvirt/images/vm-disk.qcow2 \
    -vnc 0.0.0.0:0 \
    -m 2048 \
    -smp 2 \
    -enable-kvm \
    -device virtio-net,netdev=user.0 \
    -netdev user,id=user.0,hostfwd=tcp::2222-:22 &> /var/log/qemu.log &

# Start noVNC
/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &> /var/log/novnc.log
