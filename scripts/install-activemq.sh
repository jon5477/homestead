#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
# Check If ActiveMQ Has Been Installed

if [ -e /srv/activemq/current ]
then
    echo "ActiveMQ already installed."
    exit 0
fi

# Install Java 8

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer

# Create new ActiveMQ user for Unix Daemon
useradd -m activemq -d /srv/activemq
cd /srv/activemq

# Download ActiveMQ
sudo -i -u activemq tar zxvf apache-activemq-5.15.3-bin.tar.gz
# Link ActiveMQ
sudo -i -u activemq ln -snf apache-activemq-5.15.3 current

chown -R activemq:users apache-activemq-5.15.3

# Create the SystemD init script for ActiveMQ
echo "[Unit]
Description=ActiveMQ 5.15.3 Broker
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target

[Service]
Type=forking

WorkingDir=/srv/activemq/current/bin

User=activemq
Group=users

# Prevent writes to /usr, /boot, and /etc
ProtectSystem=full

# Prevent accessing /home, /root and /run/user
ProtectHome=true

# Start main service
ExecStart=/srv/activemq/current/bin/activemq start
ExecReload=/srv/activemq/current/bin/activemq restart
ExecStop=/srv/activemq/current/bin/activemq stop

# Disable timeout logic and wait until process is stopped
TimeoutStopSec=0

KillMode=process
KillSignal=SIGTERM

# Don't want to see an automated SIGKILL ever
SendSIGKILL=no

# When a JVM receives a SIGTERM signal it exits with code 143
SuccessExitStatus=143

Restart=on-abort
RestartSec=5s" | tee /lib/systemd/system/activemq.service > /dev/null

# Enable ActiveMQ
systemctl enable activemq

# Start ActiveMQ service
systemctl start activemq
