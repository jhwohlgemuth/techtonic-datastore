#! /bin/sh

curl -O https://github.com/apptainer/apptainer/releases/download/v1.2.4/apptainer_1.2.4_amd64.deb
apt install -y ./apptainer_1.2.4_amd64.deb
rm ./apptainer_1.2.4_amd64.deb