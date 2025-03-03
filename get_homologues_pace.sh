#!/bin/bash
#SBATCH -Jget_homologues
#SBATCH --account=gts-sbrown365-paid
#SBATCH -N1 --ntasks-per-node=1
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=32G
#SBATCH -t 2:00:00
#SBATCH -q inferno
#SBATCH -o Report-%j.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nmiller304@gatech.edu


source ~/.bashrc   # Ensure conda/mamba is available
mamba activate gethomo


homologues.pl -d /storage/home/hcoda1/9/nmiller304/scratch/homolo_test -m cluster -X -M -t 0
