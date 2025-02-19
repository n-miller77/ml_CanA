#!/bin/bash

# Ensure correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <annotation_dir> <genome_parent_dir> <output_dir>"
    exit 1
fi

# Assign input arguments
ANNOTATION_DIR="$1"
GENOME_PARENT_DIR="$2"
OUTPUT_DIR="$3"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Count total annotation files
TOTAL_FILES=$(find "$ANNOTATION_DIR" -type f -name "GCA_*.gff3" | wc -l)
echo "Found $TOTAL_FILES annotation files. Starting processing..."

# Loop through each annotation file
COUNT=0
for ANNOTATION_FILE in "$ANNOTATION_DIR"/GCA_*.gff3; do
    ((COUNT++))
    
    # Extract the GCA identifier (e.g., GCA_#######.#)
    BASENAME=$(basename "$ANNOTATION_FILE")
    GCA_ID=$(echo "$BASENAME" | cut -d'_' -f1-2)  # Gets full ID like GCA_000149445.2

    # Locate the corresponding genome file
    GENOME_DIR="$GENOME_PARENT_DIR/$GCA_ID"
    GENOME_FILE=$(find "$GENOME_DIR" -type f -name "*.fna" | head -n 1)

    # Ensure genome file exists before proceeding
    if [ -z "$GENOME_FILE" ]; then
        echo "[$COUNT/$TOTAL_FILES] Warning: No genome file found for $GCA_ID in $GENOME_DIR, skipping..."
        continue
    fi

    # Define output protein file name
    PROTEIN_FILE="$OUTPUT_DIR/${GCA_ID}_proteins.faa"

    # Run gffread
    echo "[$COUNT/$TOTAL_FILES] Processing $GCA_ID..."
    gffread "$ANNOTATION_FILE" -g "$GENOME_FILE" -y "$PROTEIN_FILE"

    echo "[$COUNT/$TOTAL_FILES] Output saved to $PROTEIN_FILE"
done

echo "Processing complete. Results saved in $OUTPUT_DIR"
