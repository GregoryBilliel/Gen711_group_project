#!/bin/bash

## Started by Greg

primer="16s_V4-V5"
projname="Cyanobacteria_${primer}"
## Number of bp overlapping between forward and reverse reads required for merging in DADA2. Default is 12, but I have found that this can be relaxed to 10 for 16s V4-V5 amplicons without a significant loss of quality. This allows more reads to be retained after denoising. See
overlap=10

## trunc
trunclenf=220
trunclenr=215
    
## trim
trimleftf=0
trimleftr=0

echo "begin denoise..."

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs data/results/${projname}_demux_cutadapt.qza  \
    --p-trunc-len-f ${trunclenf} \
    --p-trunc-len-r ${trunclenr} \
    --p-trim-left-f ${trimleftf} \
    --p-trim-left-r ${trimleftr} \
    --p-n-threads ${threads} \
    --p-pooling-method 'pseudo' \
    --p-min-overlap ${overlap} \
    --p-allow-one-off \
    --o-denoising-stats data/results/${projname}_dns.qza \
    --o-base-transition-stats data/results/${projname}_base-transition.qza \
    --o-table data/results/${projname}_table.qza \
    --o-representative-sequences data/results/${projname}_rep-seqs.qza 

## Finished by Greg