# Use Ubuntu as base
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install systemd and SSH server
RUN apt-get update && \
    apt-get install -y systemd openssh-server sudo && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Set environment variables
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Expose SSH
EXPOSE 22

# Start systemd and SSH
CMD ["/usr/sbin/sshd", "-D"]
