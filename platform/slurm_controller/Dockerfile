FROM ubuntu:20.04

ARG PACKAGE_NAME="slurm-queen"

# Install SLURM
RUN apt update -y && apt install munge -y && apt install vim -y && apt install build-essential -y && apt install git -y && apt-get install mariadb-server -y && apt install wget -y

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install slurmd slurm-client slurmctld -y
RUN apt install sudo -y && apt install python3.9 python3-pip -y && useradd -m admin -s /usr/bin/bash -d /home/admin && echo "admin:admin" | chpasswd && adduser admin sudo && echo "admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt update -y && apt install libopenmpi-dev -y 

EXPOSE 6817 6818 6819 3306

# Install FastAPI Queen

# Install python packages
WORKDIR /app/${PACKAGE_NAME}
COPY ./requirements.txt /app/${PACKAGE_NAME}/requirements.txt
RUN pip install -r requirements.txt

# Copy all files to the container
COPY . /app/${PACKAGE_NAME}
WORKDIR /app/${PACKAGE_NAME}

# Copy slurm config files
COPY slurm_configs/slurm.conf /etc/slurm-llnl/
COPY slurm_configs/cgroup.conf /etc/slurm-llnl/
COPY slurm_configs/munge.key /etc/munge/
RUN chown munge /etc/munge/munge.key
RUN chmod 600 /etc/munge/munge.key

RUN chmod a+x /app/${PACKAGE_NAME}/scripts/start.sh

ENV PACKAGE_NAME=$PACKAGE_NAME
ENTRYPOINT /app/${PACKAGE_NAME}/scripts/start.sh
