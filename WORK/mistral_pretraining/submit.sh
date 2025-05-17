#!/bin/bash
#SBATCH --job-name=mistral_pretraining		# Job Name
#SBATCH -p boost_usr_prod 			# Booster Partition
#SBATCH --nodes=2                    		# Num nodes
#SBATCH --ntasks-per-node=1         		# Always 1
#SBATCH --gpus-per-task=2 			# Number of GPUs (up to 4 on Leonardo)
#SBATCH --mem-per-gpu=240GB 			# Should be 120GB * gpus-per-task on Leonardo
#SBATCH --error=job.err            		# standard error file
#SBATCH --output=job.out           		# standard output file
#SBATCH --account=EUHPC_B22_034       		# Account name (Benchmark: EUHPC_B22_034, mAiEnergy: EUHPC_A05_042)

#SBATCH --time=3:00:00                  	# Time limit

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

# Set launcher and launcher arguments:
export LAUNCHER="torchrun \
    --nnodes=$SLURM_JOB_NUM_NODES \
    --nproc_per_node=$SLURM_GPUS_ON_NODE \
    --rdzv_id=$SLURM_JOB_ID \
    --rdzv_endpoint=$MASTER_ADDR:$MASTER_PORT \
    --rdzv_backend=c10d"

# Set training script that will be executed:
export PROGRAM="axolotl.cli.train $SCRATCH/huh/config.yml"

# Run:
time srun bash -c "$LAUNCHER -m $PROGRAM"

# Clean up
deactivate
