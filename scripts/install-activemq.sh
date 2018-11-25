#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
export ACTIVEMQ_VERSION=5.15.8
# Check If ActiveMQ Has Been Installed

if [ -e /srv/activemq/current ]
then
    echo "ActiveMQ already installed."
    exit 0
fi

# Install Java 11

sudo apt-get update
sudo apt-get -y install openjdk-11-jre-headless

# Create new ActiveMQ user for Unix Daemon
sudo useradd -m activemq -d /srv/activemq
cd /srv/activemq

# Download ActiveMQ
sudo -i -u activemq curl -O -J -L "http://www.apache.org/dyn/closer.cgi?action=download&filename=/activemq/$ACTIVEMQ_VERSION/apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz"
# Extract ActiveMQ
sudo -i -u activemq tar zxvf apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz
# Link ActiveMQ
sudo -i -u activemq ln -snf apache-activemq-$ACTIVEMQ_VERSION current

sudo chown -R activemq:users apache-activemq-$ACTIVEMQ_VERSION

# Create the SystemD init script for ActiveMQ
echo "[Unit]
Description=ActiveMQ $ACTIVEMQ_VERSION Broker
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
RestartSec=5s" | sudo tee /lib/systemd/system/activemq.service > /dev/null

# Enable ActiveMQ
sudo systemctl enable activemq

# Start ActiveMQ service
sudo systemctl start activemq
