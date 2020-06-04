#!/bin/bash

set -e

# not needed for 20.04
# sudo add-apt-repository ppa:longsleep/golang-backports
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common \
                   gcc git build-essential golang-go ffmpeg nginx awscli s3fs

sudo mkdir -p /opt/streamline/manifests
sudo mkdir -p /opt/streamline/media

cd /home/ubuntu

export STREAM_KEY=${1}
export HOSTNAME=${2}
export DOMAINNAME=${3}
export INSTANCE_NAME=${4}

sudo git -C /opt clone https://github.com/zorchenhimer/MovieNight
sudo make -C /opt/MovieNight/
sudo sed -i "s/STREAM_KEY/$STREAM_KEY/g" /home/ubuntu/settings.json /home/ubuntu/movienight.service
sudo cp /opt/MovieNight/settings.json /opt/MovieNight/settings.json.orig
sudo cp /home/ubuntu/settings.json /opt/MovieNight/settings.json
sudo sed -i "s/HOSTNAME/$HOSTNAME/g" /home/ubuntu/video-hls.js 
sudo sed -i "s/DOMAINNAME/$DOMAINNAME/g" /home/ubuntu/video-hls.js
sudo cp /home/ubuntu/video-hls.js /opt/MovieNight/static/js/video-hls.js
sudo cp /opt/MovieNight/static/main.html /opt/MovieNight/static/main.html.orig
sudo sed -i "s/flv.min.js/hls.min.js/g" /opt/MovieNight/static/main.html
sudo sed -i "s/video.js/video-hls.js/g" /opt/MovieNight/static/main.html
sudo curl -s https://cdn.jsdelivr.net/npm/hls.js@latest -o /opt/MovieNight/static/js/hls.min.js
sudo chown -R ubuntu:ubuntu /opt/MovieNight
echo "MovieNight modified for hls"
sudo cp /home/ubuntu/movienight.service /etc/systemd/system/movienight.service
sudo systemctl enable movienight
sudo systemctl start movienight
echo "MovieNight part completed"
sudo curl -s -L https://github.com/kshcherban/acme-nginx/releases/download/v0.2.1/acme-nginx -o /usr/local/bin/acme-nginx
sudo chmod 755 /usr/local/bin/acme-nginx
#sudo acme-nginx -d $INSTANCE_NAME.$DOMAINNAME
sudo sed -i "s/HOSTNAME/$HOSTNAME/g" /home/ubuntu/movienight.conf
sudo sed -i "s/DOMAINNAME/$DOMAINNAME/g" /home/ubuntu/movienight.conf
sudo cp /home/ubuntu/movienight.conf /etc/nginx/sites-available/default
sudo systemctl reload nginx
echo "Nginx and ACME SSL part completed"
sudo chown -R ubuntu:ubuntu /home/ubuntu
