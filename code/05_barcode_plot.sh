#!/bin/bash

primer="16s_V4-V5"
projname="Cyanobacteria_${primer}"

## replace with the qiime2 environment youve been using 
conda activate qiime2-amplicon-2026.1

cp /tmp/GEN711-811_data/Cyanobacteria/metadata/pico-mdat.tsv data/metadata

### This script will create a barcode plot of the taxonomic composition of each sample. It will use the qiime2 feature-table and taxonomy files to create a stacked bar plot of the relative abundance of each taxon in each sample. The plot will be saved as a .png file in the data/results directory.
### NOTE: Qiime view appears to be working only in chrome. 

## To view the interactive barplot, you can use the qiime2 view command or upload the .qzv file to https://view.qiime2.org/ to interactively explore the plot. You can also export the plot as a .png file. Screenshots of the barplots work as well
## To download the .qzv file, right click on the file in vscode to download it to your local computer, then you can upload it to the qiime2 view website.

qiime feature-table filter-features \
  --i-table data/results/${projname}_table.qza \
  --m-metadata-file data/results/${projname}_hybrid_taxonomy.qza \
  --o-filtered-table data/results/${projname}_taxonomy-matched-table.qza

## Greg: Re-run this command before doing this
cp /tmp/GEN711-811_data/Cyanobacteria/metadata/pico-mdat.tsv data/metadata

qiime taxa barplot \
  --i-table data/results/${projname}_taxonomy-matched-table.qza \
  --i-taxonomy data/results/${projname}_hybrid_taxonomy.qza \
  --m-metadata-file data/metadata/pico-mdat.tsv \
  --o-visualization plots/${projname}_taxa_barplot.qzv

## Make a phylogenetic tree and run core metrics to get the alpha and beta diversity metrics for each sample. This will be used in the next script to create a PCoA plot of the beta diversity metrics.
qiime phylogeny align-to-tree-mafft-fasttree \
   --i-sequences data/results/${projname}_rep-seqs.qza \
   --o-alignment data/results/${projname}_aligned-rep-seqs \
   --o-masked-alignment data/results/${projname}_masked-aligned-rep-seqs.qza\
   --o-tree data/results/${projname}_unrooted-tree.qza\
   --o-rooted-tree data/results/${projname}_rooted-tree.qza\
   --p-n-threads 24

### Core Metrics (this will generate the alpha and beta diversity metrics for each sample, which will be used in the next script to create a PCoA plot of the beta diversity metrics)
### Choose one diversity ordination to vizualize in the readme of your github. Justify why you chose that one. You can also make multiple ordination plots if you want to compare the different beta diversity metrics.
qiime diversity core-metrics-phylogenetic \
    --i-phylogeny data/results/${projname}_rooted-tree.qza \
    --i-table data/results/${projname}_taxonomy-matched-table.qza \
    --p-with-replacement \
    --p-sampling-depth 500 \
    --m-metadata-file data/metadata/pico-mdat.tsv \
    --output-dir data/results/${projname}_core-metrics-data/

## Greg: run this command to move the .qzv files to the plots directory

mv ~/Gen711_group_project/data/results/Cyanobacteria_16s_V4-V5_core-metrics-data/*.qzv ~/Gen711_group_project/plots

## If you need to re-run the diversity core-metrics-phylogenetic command, you will need to delete the data/results/${projname}_core-metrics-data/ directory before re-running the command, otherwise you will get an error about the directory already existing. You can do this with the following command:    
rm -rf data/results/${projname}_core-metrics-data/
