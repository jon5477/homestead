#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
# Check If ActiveMQ Has Been Installed

if [ -f /home/vagrant/.activemq ]
then
    echo "ActiveMQ already installed."
    exit 0
fi

touch /home/vagrant/.activemq

