export distribution=bionic

apt-key adv --keyserver "hkps.pool.sks-keyservers.net" --recv-keys "0x6B73A36E6026DFCA"

echo "# This repository provides Erlang packages
# See below for supported distribution and component values
deb https://dl.bintray.com/rabbitmq-erlang/debian $distribution main
deb https://dl.bintray.com/rabbitmq/debian $distribution main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list > /dev/null

sudo apt-get update
sudo apt-get install -y rabbitmq-server