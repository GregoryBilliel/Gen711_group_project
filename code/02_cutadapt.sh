#!/bin/bash

### THIS IS WHERE PROJECTS BEGIN TO DIVERGE. The cutadapt parameters and primers will depend on the project. See qiime2_parameters.sh for cutadapt parameters and 01_trim.sh for polyG filter parameters.
primer="16s_V4-V5"
## primer is 16s
projname="Cyanobacteria_${primer}"
## example: projname="Cyanobac_16s_V4-V5"

echo $projname

conda activate qiime2-amplicon-2026.1

### import fastqs. Add the demultiplexed sequences to the data/results directory. This will create a .qza file that can be used for cutadapt and qiime2 downstream analyses.
qiime tools import \
    --type "SampleData[PairedEndSequencesWithQuality]"  \
    --input-format CasavaOneEightSingleLanePerSampleDirFmt \
    --input-path data/poly-G-trimmed \
    --output-path data/results/${projname}_demux 


## copied from qiime2_parameters.sh
fw='^GTGYCAGCMGCCGCGGTAA'	
rv='^CCGYCAATTYMTTTRAGTTT'
cutadapt_config="--p-front-f $fw --p-front-r $rv"

### See qiime2_parameters.sh for cutadapt parameters and 01_trim.sh for polyG filter parameters.
qiime cutadapt trim-paired \
    --i-demultiplexed-sequences data/results/${projname}_demux.qza \
    --p-error-rate 0.12 \
    --o-trimmed-sequences data/results/${projname}_demux_cutadapt.qza \
    --p-cores 4 \
    --p-front-f ^GTGYCAGCMGCCGCGGTAA \
    --p-front-r ^CCGYCAATTYMTTTRAGTTT \
    --p-discard-untrimmed \
    --p-match-adapter-wildcards \
    --verbose 

qiime demux summarize \
    --i-data data/results/${projname}_demux_cutadapt.qza \
    --o-visualization data/results/${projname}_demux_cutadapt.qzv