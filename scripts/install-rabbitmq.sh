export distribution=bionic

wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | sudo apt-key add -

echo "# This repository provides Erlang packages
# See below for supported distribution and component values
deb https://dl.bintray.com/rabbitmq-erlang/debian $distribution erlang
deb https://dl.bintray.com/rabbitmq/debian $distribution main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list > /dev/null

sudo apt-get update
sudo apt-get install -y rabbitmq-server

sudo rabbitmq-plugins enable rabbitmq_management

sudo rabbitmqctl add_user admin admin
sudo rabbitmqctl set_user_tags admin administrator
sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
