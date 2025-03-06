#!/bin/bash
#SBATCH -Jget_homologues
#SBATCH --account=gts-sbrown365-paid
#SBATCH -N1 --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=32G
#SBATCH -t 5:00:00
#SBATCH -q inferno
#SBATCH -o Report-%j.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nmiller304@gatech.edu


source ~/.bashrc   # Ensure conda/mamba is available
mamba activate gethomo2


get_homologues.pl -d /storage/home/hcoda1/9/nmiller304/scratch/99ID/stricter_geth_test -M -t=0 -S 90 -C 99
