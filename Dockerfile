FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Basic setup
RUN apt update && \
    apt install -y systemd openssh-server curl sudo gnupg ca-certificates && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Install Node.js (for Wetty)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt install -y nodejs && \
    npm install -g wetty

# Create a launch script
RUN echo '#!/bin/bash\n\
/usr/sbin/sshd\n\
wetty --port 3000 --ssh-host 127.0.0.1 --ssh-user root --ssh-port 22' > /start.sh && \
    chmod +x /start.sh

# Expose web terminal and SSH
EXPOSE 3000 22

CMD ["/start.sh"]
