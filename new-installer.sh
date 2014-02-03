#!/bin/bash -eu

# Copyright 2014 tsuru authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

echo Installing curl
apt-get update
apt-get install curl -qqy

echo Installing apt-add-repository
apt-get install python-software-properties -qqy

echo Adding Docker repository
curl https://get.docker.io/gpg | apt-key add -
echo "deb http://get.docker.io/ubuntu docker main" | sudo tee /etc/apt/sources.list.d/docker.list

echo Adding Tsuru repository
apt-add-repository ppa:tsuru/ppa -y

echo Installing remaining packages
apt-get update
apt-get install lxc-docker tsuru-node-agent -qqy

echo Configuring and starting Docker
sed -i.old -e 's;/usr/bin/docker -d;/usr/bin/docker -H tcp://127.0.0.1:4243 -d;' /etc/init/docker.conf
rm /etc/init/docker.conf.old
stop docker
start docker
