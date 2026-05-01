#!/bin/bash

## IF THIS DOES NOT WORK, TRY AND PUT data/ BEFORE THE metadata/ ON LINES 13, 30 and 49!!!

primer="16s_V4-V5"
projname="Cyanobacteria_${primer}"

## replace with the qiime2 environment youve been using 
conda activate qiime2-amplicon-2026.1

### This script will create a barcode plot of the taxonomic composition of each sample. It will use the qiime2 feature-table and taxonomy files to create a stacked bar plot of the relative abundance of each taxon in each sample. The plot will be saved as a .png file in the data/results directory.
### NOTE: Qiime view appears to be working only in chrome. 
qiime taxa barplot \
  --i-table data/results/${projname}_table.qza \
  --i-taxonomy data/results/${projname}_hybrid_taxonomy.qza \
  --m-metadata-file data/metadata/pico-mdat.tsv \
  --o-visualization data/results/${projname}_taxa_barplot.qzv

## ERROR WHEN I TRIED TO RUN IT:
## Plugin error from taxa:

 ## Sample IDs found in the table are missing in the metadata: {'WLW-VP', '18-1-100', '32-1-100', '26-1-100', 'PAC', 'WLW-TK', 'AIR-EW', 'AIR-VP', 'AIR-TK', 'XB', '28-1-100', '40-100', 'NTC', 'WLW-EW', '29-1-100', '21-1-100', '23-1-100', '3-1-100', '24-1-100', '2-1-100', '12-1-100'}.
##Debug info has been saved to /tmp/qiime2-q2cli-err-cjdwf66f.log

## To view the interactive barplot, you can use the qiime2 view command or upload the .qzv file to https://view.qiime2.org/ to interactively explore the plot. You can also export the plot as a .png file. Screenshots of the barplots work as well
## To download the .qzv file, right click on the file in vscode to download it to your local computer, then you can upload it to the qiime2 view website.


## If you get an error form the barplotabout missing IDs, try this:

qiime feature-table filter-features \
  --i-table data/results/${projname}_table.qza \
  --m-metadata-file data/results/${projname}_hybrid_taxonomy.qza \
  --o-filtered-table data/results/${projname}_taxonomy-matched-table.qza

## In the --i-table input I think the file is wrong for this one, the output above gives taxonomy-matched-table.qza while the input for this second command needs a filtered-table.qza. Still think the issue is a metadata file issue vs a command issue

qiime taxa barplot \
  --i-table data/results/${projname}_taxonomy-matched-table.qza \
  --i-taxonomy data/results/${projname}_hybrid_taxonomy.qza \
  --m-metadata-file data/metadata/pico-mdat.tsv \
  --o-visualization plots/${projname}_taxa_barplot.qzv

  ## still getting error: Plugin error from taxa:

 ## Sample IDs found in the table are missing in the metadata: {'XB', 'AIR-VP', 'PAC', '29-1-100', '18-1-100', '28-1-100', '32-1-100', '3-1-100', 'AIR-EW', 'WLW-TK', '24-1-100', '40-100', '12-1-100', 'WLW-EW', 'AIR-TK', '26-1-100', '21-1-100', '2-1-100', 'NTC', '23-1-100', 'WLW-VP'}.

## Debug info has been saved to /tmp/qiime2-q2cli-err-ckslvew0.log

## Make a phylogenetic tree and run core metrics to get the alpha and beta diversity metrics for each sample. This will be used in the next script to create a PCoA plot of the beta diversity metrics.
qiime phylogeny align-to-tree-mafft-fasttree \
   --i-sequences data/results/${projname}_rep-seqs.qza \
   --o-alignment data/results/${projname}_aligned-rep-seqs \
   --o-masked-alignment data/results/${projname}_masked-aligned-rep-seqs.qza\
   --o-tree data/results/${projname}_unrooted-tree.qza\
   --o-rooted-tree data/results/${projname}_rooted-tree.qza\
   --p-n-threads 24

## --m-metadata-file part is screwy, will more then likely need to change thats

### Core Metrics (this will generate the alpha and beta diversity metrics for each sample, which will be used in the next script to create a PCoA plot of the beta diversity metrics)
### Choose one diversity ordination to vizualize in the readme of your github. Justify why you chose that one. You can also make multiple ordination plots if you want to compare the different beta diversity metrics.
qiime diversity core-metrics-phylogenetic \
    --i-phylogeny data/results/${projname}_rooted-tree.qza \
    --i-table data/results/${projname}_samp_filtered-table.qza \
    --p-with-replacement \
    --p-sampling-depth 500 \
    --m-metadata-file data/metadata/${projname}_metadata.tsv \
    --output-dir data/results/${projname}_core-metrics-data/

## If you need to re-run the diversity core-metrics-phylogenetic command, you will need to delete the data/results/${projname}_core-metrics-data/ directory before re-running the command, otherwise you will get an error about the directory already existing. You can do this with the following command:    
rm -rf data/results/${projname}_core-metrics-data/
