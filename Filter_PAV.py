import csv

# Define input and output files
input_file = "input.tsv"
output_file = "output.tsv"
allowed_columns_file = "allowed_columns.txt"

# Read the allowed column names
with open(allowed_columns_file, "r") as f:
    allowed_columns = set(line.strip() for line in f)

# Process the TSV file
with open(input_file, "r") as infile, open(output_file, "w", newline='') as outfile:
    reader = csv.reader(infile, delimiter='\t')
    writer = csv.writer(outfile, delimiter='\t')
    
    # Read the header and determine the columns to keep
    header = next(reader)
    indices_to_keep = [0] + [i for i, col in enumerate(header) if col in allowed_columns]
    
    # Write the filtered data
    writer.writerow([header[i] for i in indices_to_keep])
    for row in reader:
        writer.writerow([row[i] for i in indices_to_keep])
