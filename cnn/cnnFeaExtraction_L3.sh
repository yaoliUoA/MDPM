#!/bin/sh
#PBS -l nodes=1:ppn=1,vmem=2G,walltime=30:00:00
#PBS -o cnnFeaExtraction_L3_${PBS_ARRAYID}.log
#PBS -o cnnFeaExtraction_L3_${PBS_ARRAYID}.err
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/OpenBLAS/lib:$LD_LIBRARY_PATH
cd $PBS_O_WORKDIR # Go to the directory the job was started in
matlab -singleCompThread -nojvm -nosplash -nodesktop -r "cnnFeaExtraction_L3(${PBS_ARRAYID}); quit;"