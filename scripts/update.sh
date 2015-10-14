#!/bin/bash -eux
# Disable the release upgrader
echo "Disabling the release upgrader..."$(date '+%T')
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades
echo "Updating list of repositories...."$(date '+%T')
# apt-get update does not actually perform updates, it just downloads and indexes the list of packages
apt-get -y update >/dev/null 2>&1
if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    echo "Performing dist-upgrade.........."$(date '+%T')
    apt-get -y dist-upgrade --force-yes >/dev/null 2>&1
    reboot
    sleep 60
fi