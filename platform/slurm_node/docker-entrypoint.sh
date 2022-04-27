#!/bin/bash

sudo sed -i "s/REPLACE_IT/CPUs=$(nproc)/g" /etc/slurm-llnl/slurm.conf

sudo service munge start
sudo slurmd -N $(hostname)

sudo chmod 777 /var/run/docker.sock

tail -f /dev/null
