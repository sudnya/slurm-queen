#! /bin/bash

# Safely execute this bash script
# e exit on first failure
# u unset variables are errors
# f disable globbing on *
# pipefail | produces a failure code if any stage fails
set -euf -o pipefail

# Get the directory of this script
LOCAL_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

<<<<<<< HEAD
sudo sed -i "s/REPLACE_IT/CPUs=$(nproc)/g" /etc/slurm-llnl/slurm.conf

sudo service munge start
sudo service slurmctld start
=======
sed -i "s/REPLACE_IT/CPUs=$(nproc)/g" /etc/slurm-llnl/slurm.conf

service munge start
service slurmctld start
>>>>>>> 937fcef (ENH: Added slurm queen endpoints in fastapi.)

# Start the dev environment
PYTHONPATH=$LOCAL_DIRECTORY/.. uvicorn --host "0.0.0.0" slurm_queen:app --reload


