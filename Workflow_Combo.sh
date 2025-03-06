# First need to download NCBI genomes
# Make mamba env with augustus and gffread and busco
# Make mamba env with get_homologues 

-- Initial Genome Annotation --
# activate first env #

#after downloading fna file, annotate with AUGUSTUS
#starts with reference species(uses candida albicans cause its closest they have) -turn on gff3 output -genome  then > output_file
augustus --species=candida_albicans --gff3=on <input_genome_file> > <output_file_name>.gff3

#pull out proteins using gffreads
gffread <output_file_name>.gff3 -g <input_genome_file> -y <output_protein_file>.faa


#clean up the faa files (after putting them into a shared dir) ---- will replace any . not in the header with X to be consistent
sed -i 's/\([A-Za-z]\)\.$/\1X/g' ./*.faa
sed -i 's/\([A-Za-z]\)\.\([A-Za-z]\)/\1X\2/g' ./*.faa





-- running get_homologues --
# there are two options. If you are just running 10 or less, you can just activate your env and then run this:
# -M says to use MCL clustering, -t specifies the number of genomes required per cluster (want 0 so it includes everything, default is clusters must include all genomes), -S is minimum sequence identity in blast, -C is miimum percent coverage for clusters
get_homologues.pl -d <path/to/protein/files> -M -t=0 -S 90 -C 99

# If you are running more genomes, you will want to run it with the diamond option stated
# In order to run this, you will have to gitclone get_homologues. Then, you will need to go to the file ./get_homologues/lib/marfil_homology.pm
# In tht file, locate the blastp query and remove --seg = yes ... save and then it shold work
# Will need to run the script in the get_homologues directory with the mamba env activated for it to work
./get_homologues.pl -d <path/to/protein/files> -M -t=0 -S 90 -C 99 -X



-- creating PAV matrix --
# this will allow you to create the PAV matrix for the clusters
compare_clusters.pl -o <output_dir> -m -d <input_dir -- should be the first dir in the file>






-- Optional step to see genome completeness, not optimized so has to be done one at a time --
#run busco for genome completness -genome_file -output_dir -generic_euk_comparison
busco -i GCA_003013715.2_ASM301371v2_genomic.fna -o busco_output -l eukaryota_odb10 -m genome --augustus_species=candida_albicans
