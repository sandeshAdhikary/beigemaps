# Beigemaps
This is the companion website for our paper BeigeMaps: Behavioral Eigenmaps for Reinforcement Learning from Images (ICML, 2024).

## Setup
### Without Docker
1. Clone the repo
   ```
   git clone git@github.com:sandeshAdhikary/beigemaps.git
   ```
3. Create a conda environment
   ```
   conda env create -f conda_env.yaml -v
   ```
4. Install trainer and src as packages
   ```
   bash setup.sh
   ```

### With Docker
1. We provide a Dockerfile that tries to match the machine settings used in our experiments. This is a relatively bare-bones image that has the pre-requisites of running DM control experiments.  Clone the repo, and build the Docker image. You might have to use sudo for docker commands.
   ```
   git clone git@github.com:sandeshAdhikary/beigemaps.git
   cd beigemaps
   docker build -t beigemaps .
   ```
2. This will build an image called 'beigemaps' on your machine with the conda environment already set up. The docker-compose.yaml file defines a container with a single GPU and appropriate volume mounts
   ```
   docker compose up -d
   ```
3. Once the container is built, you can attach to it using
   ```
   docker attach beigemaps
   ```
4. Once you're in the container, run initial setup steps
   ```
   bash setup.sh
   ```

Note that the tag used when building the image should match the tag name specified in the docker-compose file.

## Training an Agent
Experiments are run using the file ``src/studies/dm_control_study/study.py``.

For example, to train a model on the ``cheetah_run`` environment using the ``beigemap_dbc`` algorithm, run this:
```
cd src/studies/dm_control_study
python study.py +study=dm_control_study +project=cheetah_run +exp=beigemap_ksme ++exp.exp_mode=train
```
Right now, logging is done through Weights and Biases so you'll be prompted for your W&B account info when you run this command. We are currently working on an alternate Tensorboard logging option.

### Running Training Sweeps
The exp config files define a sweep across multiple seeds. We keep track of sweeps using Weights and Biases. So if you run the same training command on multiple machines (but all using the same W&B credentials), W&B will keep track of the experiments that may be running elsewhere. 

For example, if seed 1 is already running on some machine, we'll move on to seed 2 when the same training command is run on the same or a different machine. Also, say that the training for seed 1 was interrupted and it is currently paused. Then, running the training command above will first try to resume any paused runs before starting a new one.
You can also adjust the sweep parameters in the exp config file to define sweeps on parameters other than the random seed.

## Setting up Configs
All experiment parameters are defined in config files in ``src/studies/dm_control_study/configs``.

We've modularized experiment configs into ``studies > projects > experiments``. 

1. **Default Config**
The default_config.yaml file has all the default configs, some of which will get overwritten by the project and exp configs. 
2. **Study Configs**
All experiments use the same study config dm_control_study, but you can define a new study if needed.
3. **Project Configs**
Each of these config files is associated with a specific environment, e.g. ``cheetah_run.yaml``.
4. **Exp Configs**
Each of these config files is associated with a specific algorithm, e.g., ``beigemap_ksme.yaml``.

In the run command we used to train models, the ``+project=cheetah_run`` and ``+exp=beigemap_ksme`` specify the project and exp config files that overwrite values in the default config.

## Logs and Outputs
The training log files will be stored in the folder `logdir`. You can change the default logdir in the environment file definition in `src/studies/dm_control_study/.env`
The evalution outputs (e.g. videos) and saved models will be saved in the storage folder

## Advanced: Setting up SSH Storage
You can set up the code to save outputs (videos, models, etc.) to an SSH storage. Besides storage issues, this can also be useful in defining a central storage for experiments run on multiple computers.
Instructions coming soon...

## Acknowledgements
1. This codebase builds upon and uses code from https://github.com/facebookresearch/deep_bisim4control
2. We also use reference code for comparison models using their respective Github repo codebases: [Robust DBC](https://github.com/metekemertas/RobustBisimulation), [Reducing Approximation Gap](https://github.com/jianda-chen/RAP_distance/tree/main), [Kernel Similarity Metric](https://github.com/google-research/google-research/tree/master/ksme).

## Citation
If you use this repo in your own work, please consider using the following citation
```
@InProceedings{AdhikaryLiBootsBeigeMaps2024,
  title = 	 {BeigeMaps: Behavioral Eigenmaps for Reinforcement Learning from Images},
  author =       {Adhikary, Sandesh and Li, Anqi and Boots, Byron},
  booktitle = 	 {Proceedings of the 41st International Conference on Machine Learning},
  year = 	 {2024},
  publisher =    {PMLR},
}
```

