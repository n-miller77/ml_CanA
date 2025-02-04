--- mamba activate orthofinder --
#after downloading fna file, annotate with AUGUSTUS
#starts with reference species(uses candida albicans cause its closest they have) -turn on gff3 output -genome  then > output_file
augustus --species=candida_albicans --gff3=on GCA_003013715.2_ASM301371v2_genomic.fna > Canchrom_annotations.gff3

-- mamba acticate busco --
#run busco 
#run busco for genome completness -genome_file -output_dir -generic_euk_comparison
busco -i GCA_003013715.2_ASM301371v2_genomic.fna -o busco_output -l eukaryota_odb10 -m genome --augustus_species=candida_albicans

#pull out proteins using gffreads
gffread Canchrom_annotations.gff3 -g GCA_003013715.2_ASM301371v2_genomic.fna -y Canchrom_proteins.faa

#busco in protein-mode, less completeness for some reason
busco -i Canschrom_proteins.faa -o 2_busco_output -l eukaryota_odb10 -m proteins

#
