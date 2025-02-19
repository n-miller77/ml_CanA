#!/bin/bash

# Ensure correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <genome_parent_dir> <output_dir> <busco_db>"
    exit 1
fi

# Assign input arguments
GENOME_PARENT_DIR="$1"
OUTPUT_DIR="$2"
BUSCO_DB="$3"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Count total GCF & GCA genome directories
TOTAL_FILES=$(find "$GENOME_PARENT_DIR" -mindepth 1 -maxdepth 1 -type d \( -name "GCF_*" -o -name "GCA_*" \) | wc -l)
echo "Found $TOTAL_FILES genome directories (GCF & GCA). Starting BUSCO analysis..."

# Loop through each GCF or GCA genome directory
COUNT=0
for GENOME_DIR in "$GENOME_PARENT_DIR"/GCF_* "$GENOME_PARENT_DIR"/GCA_*; do
    # Ensure it exists (prevents errors if no GCA or GCF directories are found)
    [ -d "$GENOME_DIR" ] || continue
    
    ((COUNT++))

    # Extract the identifier (e.g., GCF_000149445.2 or GCA_000149445.2)
    GENOME_ID=$(basename "$GENOME_DIR")

    # Locate the corresponding genome file (.fna)
    GENOME_FILE=$(find "$GENOME_DIR" -type f -name "*.fna" | head -n 1)

    # Ensure genome file exists before proceeding
    if [ -z "$GENOME_FILE" ]; then
        echo "[$COUNT/$TOTAL_FILES] Warning: No genome file found for $GENOME_ID in $GENOME_DIR, skipping..."
        continue
    fi

    # Define output directory for this genome
    BUSCO_OUTPUT="$OUTPUT_DIR/${GENOME_ID}_busco"

    # Run BUSCO
    echo "[$COUNT/$TOTAL_FILES] Running BUSCO on $GENOME_ID..."
    busco -i "$GENOME_FILE" -o "$BUSCO_OUTPUT" -l "$BUSCO_DB" -m genome --augustus_species=candida_albicans

    echo "[$COUNT/$TOTAL_FILES] BUSCO output saved to $BUSCO_OUTPUT"
done

echo "Processing complete. Results saved in $OUTPUT_DIR"
