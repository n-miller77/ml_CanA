#-m specifies cluster vs local (default is local)
# -X uses diamond instead of blastp
#-M uses orthoMCL algorithm instead of bidirectional best hits 
#-c report genome composition analysis 
# -C % sequence similarity for blast pairwise analysis 
# -S min %sequence identity in BLAST query/subj pairs
#-x allow sequences in multiple COG clusters
#-t report sequence clusters including at least t taxa
# -A calculate average identity of clustered sequences --- better to leave this off to reduce walltime 
#-P calculate percentage of conserved proteins (POCP)
get_homologues.pl -d <directory>
(((add this: -m cluster -X)))

get_homologues.pl -d <directory> -m local -n 20 -X


homologues.pl -d <directory> -m cluster -X -t 0 -M
homologues.pl -d <directory> -m cluster -X -M -t 0

#to compare clusters 
compare_clusters.pl -o sample_intersection -d \
sample_buch_fasta_homologues/BuchaphCc_f0_alltaxa_algBDBH_e0_, \
sample_buch_fasta_homologues/BuchaphCc_f0_alltaxa_algCOG_e0_, \
sample_buch_fasta_homologues/BuchaphCc_f0_alltaxa_algOMCL_e0_


get_homologues.pl -d sample_plasmids_gbk -t 0 -G (((-t 0)))) will resport clusters that may only have one in it 
get_homologues.pl -d sample_plasmids_gbk -t 0 -M will report less clusters 


#comparing clusters: 
compare_clusters.pl -o sample_intersection -m -d \
sample_plasmids_gbk_homologues/Uncultured[...]_f0_0taxa_algCOG_e0_,\
sample_plasmids_gbk_homologues/Uncultured[...]_f0_0taxa_algOMCL_e0_


# does some types of phylogeny stuff 
compare_clusters.pl -o sample_intersection -m -T -d

#analyzes pangeome matrix: 
parse_pangenome_matrix.pl -m sample_intersection/pangenome_matrix_t0.tab \
-A sample_plasmids_gbk/A.txt -B sample_plasmids_gbk/B.txt -g
