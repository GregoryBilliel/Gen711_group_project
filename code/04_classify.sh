#!/bin/bash
## Started by Greg

## made changes here

primer="16s_V4-V5"
projname="Cyanobacteria_${primer}"

## Classifiy
refreads="~/Gen711_group_project/refdbs/ref_seqs_16S_V4-V5.qza"
reftax="~/Gen711_group_project/refdbs/99_otus_16S_taxonomy.qza"
sklearn="~/Gen711_group_project/refdbs/silva_99_otus_16S_nb-classifier.qza"


## copied from qiime2_parameters.sh
maxaccepts=10
query_cov=0.75 
perc_identity=0.75 
weak_id=0.65

## can set threads to equal what you want, I went with threads=16 and it took about 50~ minutes to run this 
## I think the max is 24 you can set it to

qiime feature-classifier classify-hybrid-vsearch-sklearn \
  --i-query data/results/${projname}_rep-seqs.qza \
  --i-classifier ${sklearn} \
  --i-reference-reads ${refreads} \
  --i-reference-taxonomy  ${reftax} \
  --p-threads ${threads} \
  --p-query-cov ${query_cov} \
  --p-perc-identity ${perc_identity} \
  --p-maxrejects all \
  --p-maxaccepts ${maxaccepts} \
  --p-maxhits all \
  --p-min-consensus 0.51 \
  --p-confidence 0.7 \
  --o-classification data/results/${projname}_hybrid_taxonomy

## finished by Greg