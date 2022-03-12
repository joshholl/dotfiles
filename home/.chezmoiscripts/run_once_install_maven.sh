#!/bin/bash 

if [ ! -d ${HOME}/.opt ]; then
 mkdir ${HOME}/.opt 
fi

wget -O apache-maven-3.8.4-bin.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz
tar zxf apache-maven-3.8.4-bin.tar.gz
ls -la
mv apache-maven-3.8.4 ${HOME}/.opt/apache-maven-3.8.4
ln -s ${HOME}/.opt/apache-maven-3.8.4 ${HOME}/.opt/maven
rm apache-maven-3.8.4-bin.tar.gz

