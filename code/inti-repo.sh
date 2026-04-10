mdkir plots
mdkir code
mdkir results
mdkir data
mkdir data/fastqs

#!/bin/bash
conda activate genomics
cd ~/jasperCement

mkdir -p poly-G-trimmed html results metadata data/fastqs

cd data/fastqs

polyg_len=200

chmod +x ../code/polyGfilter.sh
../code/polyGfilter.sh ${polyg_len}

Greg: ported the code folder files in and organized the project repo a little bit
