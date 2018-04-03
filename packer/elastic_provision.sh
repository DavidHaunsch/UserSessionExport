#!/usr/bin/env bash

set -e

sudo apt-get -y update
sudo apt -y install openjdk-8-jre-headless

# nginx
sudo apt-get -y install nginx

# elastic
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get -y install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get -y update
sudo apt-get -y install elasticsearch
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2

# kibana
sudo apt-get -y install kibana

# install x-pack
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack --batch
sudo /usr/share/kibana/bin/kibana-plugin install x-pack

# copy configuration files
sudo cp /home/ubuntu/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
sudo cp /home/ubuntu/kibana.yml /etc/kibana/kibana.yml
sudo cp /home/ubuntu/sites-available-default /etc/nginx/sites-available/default
