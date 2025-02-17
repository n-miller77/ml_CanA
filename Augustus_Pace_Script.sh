#!/bin/bash
#SBATCH -JRunningAugustus
#SBATCH --account=gts-sbrown365-paid
#SBATCH -N1 --ntasks-per-node=1
#SBATCH --mem-per-cpu=32G
#SBATCH -t 24:00:00
#SBATCH -q inferno
#SBATCH -o Report-%j.out
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=nmiller304@gatech.edu


source ~/.bashrc   # Ensure conda/mamba is available
mamba activate orthofinder  

# Define input and output directories
Input="/storage/scratch1/9/nmiller304/data"      
Output="/storage/scratch1/9/nmiller304/candida_output"    



mkdir -p "$Output"



for SUBDIR in "$Input"/*/; do
    Genome=$(find "$SUBDIR" -type f -name "*.fna")
    if [[ -n "$Genome" ]]; then 
        BASENAME=$(basename "$SUBDIR")
        OutputFile="$Output/${BASENAME}_annotations.gff3"

        if [[ -f "$OutputFile" ]]; then
            echo "Skipping $BASENAME: annotation already exists."
        else
            echo "Processing $BASENAME..."
            augustus --species=candida_albicans --gff3=on "$Genome" > "$OutputFile"
        fi
    fi
done
