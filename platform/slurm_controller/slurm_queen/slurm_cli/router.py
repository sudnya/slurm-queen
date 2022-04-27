
<<<<<<< HEAD
from slurm_queen.util.config import get_config

import subprocess

import tempfile
=======

>>>>>>> 937fcef (ENH: Added slurm queen endpoints in fastapi.)
import logging

logger = logging.getLogger(__name__)

<<<<<<< HEAD
def run(job_config: dict):
    logger.info("Run {}".format(job_config))

    config = get_config()

    with tempfile.NamedTemporaryFile(mode="w", dir=config["slurm_queen"]["home_path"]) as bash_script_file:
        bash_script_path = bash_script_file.name

        script_contents = """#!/bin/bash
        sleep 10
        echo "Running job!"
        """

        bash_script_file.write(script_contents)       
        bash_script_file.flush()

        run_command = ["sbatch", bash_script_path]
        result = subprocess.run(run_command, cwd=config["slurm_queen"]["home_path"], stdout = subprocess.PIPE)
    return {
        "message" : result.stdout
    }
=======
def run(config: dict):
    logger.info("Run {}".format(config))

>>>>>>> 937fcef (ENH: Added slurm queen endpoints in fastapi.)

def get_queue():
    logger.info("Get queue")

<<<<<<< HEAD
    config = get_config()
    run_command = ["squeue"]
    result = subprocess.run(run_command, cwd=config["slurm_queen"]["home_path"], stdout = subprocess.PIPE)

    return {
        "message" : result.stdout
    }
=======
>>>>>>> 937fcef (ENH: Added slurm queen endpoints in fastapi.)

def info():
    logger.info("Info")

<<<<<<< HEAD
    config = get_config()
    run_command = ["sinfo"]
    result = subprocess.run(run_command, cwd=config["slurm_queen"]["home_path"], stdout = subprocess.PIPE)

    return {
        "message" : result.stdout
    }

def status(id: int):
    logger.info("Status {}".format(id))

    config = get_config()

    run_command = ["scontrol", "show", "jobid", "-dd", str(id)]
    result = subprocess.run(run_command, cwd=config["slurm_queen"]["home_path"], stdout = subprocess.PIPE)

    return {
        "message" : result.stdout
    }
=======
>>>>>>> 937fcef (ENH: Added slurm queen endpoints in fastapi.)

def cancel(id: int):
    logger.info("Cancel {}".format(id))

<<<<<<< HEAD
    config = get_config()
    run_command = ["scancel", str(id)]
    result = subprocess.run(run_command, cwd=config["slurm_queen"]["home_path"], stdout = subprocess.PIPE)

    return {
        "message" : result.stdout
    }

=======
>>>>>>> 937fcef (ENH: Added slurm queen endpoints in fastapi.)
