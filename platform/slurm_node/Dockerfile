FROM ubuntu:20.04

RUN apt update -y && apt install munge -y && apt install vim -y && apt install build-essential -y && apt install git -y && apt-get install mariadb-server -y && apt install wget -y

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install slurmd slurm-client -y
RUN apt install sudo -y && apt install python3.9 python3-pip -y && useradd -m admin -s /usr/bin/bash -d /home/admin && echo "admin:admin" | chpasswd && adduser admin sudo && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt update -y && apt install libopenmpi-dev -y && apt install -y docker.io

COPY slurm_configs/slurm.conf /etc/slurm-llnl/
COPY slurm_configs/cgroup.conf /etc/slurm-llnl/
COPY slurm_configs/munge.key /etc/munge/
COPY docker-entrypoint.sh /etc/slurm-llnl/

RUN chown munge /etc/munge/munge.key
RUN chmod 600 /etc/munge/munge.key
RUN usermod -aG docker admin

EXPOSE 6817 6818 6819

ENTRYPOINT ["/etc/slurm-llnl/docker-entrypoint.sh"]
