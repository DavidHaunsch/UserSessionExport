#!/usr/bin/env bash

set -e

sudo apt-get -y update
sudo apt -y install openjdk-8-jre-headless
wget -nv http://dexya6d9gs5s.cloudfront.net/latest/dynatrace-easytravel-linux-x86_64.jar
java -jar dynatrace-easytravel-linux-x86_64.jar -y

# change configuration
sed -i 's/config.apmServerDefault=Classic/config.apmServerDefault=APM/g' /home/ubuntu/easytravel-2.0.0-x64/resources/easyTravelConfig.properties
sudo cp /home/ubuntu/easytravel.service /etc/systemd/system/
sudo cp /home/ubuntu/uemload.service /etc/systemd/system/
