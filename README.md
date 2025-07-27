# Getting Started

Before going through this getting started guide, make sure to read through the [Leonardo User Guide](https://docs.hpc.cineca.it/index.html).

> [!IMPORTANT]
> The setup has been replicated for **EUHPC_B22_034** and for **EUHPC_A05_042** (mAiEnergy)

## File Structure

We will utilize both the `$FAST` as well as the `$WORK` directory for Training. The cached dependencies (e.g., pip cache, HuggingFace model cache, etc.) will reside in the `$FAST` directory, while all training specific directories will be solely placed in the `$WORK` directory. 

## Installing Dependencies

* Place the `default` modules file in the `$HOME/.module/` directory
	* This allows you to load the same Leonardo-specific dependencies by running `module restore ~/.module/default`
	* To make sure the modules are always loaded after connecting, run: `echo "module restore ~/.module/default" >> ~/.bashrc`
* Make sure the modules were loaded correctly by running:
	* `python -V` and
	* `gcc -v`

## Environment Variables

Make sure that the following env variables are set correctly:
* HF_HOME
* TRANSFORMERS_CACHE
* HF_DATASETS_CACHE

The easiest way to make sure the variables are set correctly is to run:
```bash
echo "export HF_HOME=$FAST/.cache/huggingface" >> ~/.bashrc
echo "export TRANSFORMERS_CACHE=$HF_HOME/transformers" >> ~/.bashrc
echo "export HF_DATASETS_CACHE=$HF_HOME/datasets" >> ~/.bashrc
```
## Training

For creating a new experiment, use the `new_experiment` shell script:
```bash
./new_experiment -n <EXPERIMENT_NAME>
```

Depending on the needed scenario, certain parameters need to be changed in either the `config.yml` or `submit.sh`.

The `config.yaml` controls all parameters regarding training, for example:
* (Continued Pre-)Training or Fine-tuning dataset
* Learning rate
* Optimizer
* Base model
* Number of epochs
* ...

The `submit.sh` controls the scheduling of the the training on the nodes and GPUs:
* Number of nodes
* Number of GPUs per node
* Max. Training Time
* Memory per GPU
* ...

> [!IMPORTANT]
> Make sure that the necessary base models are already downloaded from HuggingFace and placed in the cache correctly. This is necessary, as the compute nodes can't access outside resources.

After tweaking these parameters, the job can be submitted to the SLURM scheduler by running:
```bash
sbatch submit.sh
```

The current state of all scheduled jobs (for a particular user) can be queried by running:
```bash
squeue --me -l
```

## Post-training

After training you will find a directory(usually model-out/) containing the LoRA adapters.
The next step after training is then to merge these fine-tuned adapters back into the base model.

For that there is a separate submit_merge.sh script.

It will take the `config.yml` file and the LoRA directory to merge the adapters into the base model, the output will then be the final *.safetensors files  in `model-out/merged/`.


# More Information

* [Leonardo User Guide](https://docs.hpc.cineca.it/index.html)
	* Contains more info regarding Leonardo and the SLURM scheduler
* [Axolotl](https://docs.axolotl.ai/)
	* This is the main library used for training/fine-tuning
	* This might be particularly important: [Dataset Formats](https://docs.axolotl.ai/docs/dataset-formats/)
* [LLMs-on-supercomputers](https://gitlab.tuwien.ac.at/vsc-public/training/LLMs-on-supercomputers/-/tree/main?ref_type=heads)
	* Contains examples for training LLMs on Leonardo
