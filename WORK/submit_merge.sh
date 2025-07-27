#!/bin/bash
#SBATCH --job-name={JOB_NAME}			# Job Name
#SBATCH -p boost_usr_prod 			# Booster Partition
#SBATCH --nodes=1                    		# Number of nodes
#SBATCH --ntasks-per-node=1         		# Always 1
#SBATCH --gpus-per-task=1 			# Number of GPUs (up to 4 on Leonardo)
#SBATCH --mem-per-gpu=120GB 			# Should be 120GB * gpus-per-task on Leonardo (Example: 240GB) for 2 GPUs
#SBATCH --error=job.err            		# standard error file
#SBATCH --output=job.out           		# standard output file
#SBATCH --account=EUHPC_A05_042       		# Account name (Benchmark: EUHPC_B22_034, mAiEnergy: EUHPC_A05_042)
#SBATCH --cpus-per-task=8  			# Should be 8 * gpus-per-task on Leonardo

#SBATCH --time=24:00:00               		# Time limit Example: 3:00:00 (3 hours)

# Actual Job script
module restore
source $FAST/venv/bin/activate

export HF_HUB_OFFLINE=1
export LD_LIBRARY_PATH=$(gcc -print-file-name=libstdc++.so.6 | xargs dirname):$LD_LIBRARY_PATH

# Include commands in output:
set -x

# Print current time and date:
date

# Print host name:
hostname

# List available GPUs:
nvidia-smi

# Set environment variables for communication between nodes:
export MASTER_PORT=$(shuf -i 20000-30000 -n 1)  # Choose a random port
export MASTER_ADDR=$(scontrol show hostnames ${SLURM_JOB_NODELIST} | head -n 1)

# Run:
time srun axolotl merge-lora config.yml --lora-model-dir="{PATH_TO_LORA_DIR}"

# Clean up
deactivate
