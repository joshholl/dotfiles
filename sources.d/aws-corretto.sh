#!/bin/sh

wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - 
echo 'deb https://apt.corretto.aws stable main' | sudo tee /etc/apt/sources.list.d/aws-corretto.list

