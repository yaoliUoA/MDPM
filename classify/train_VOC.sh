#!/bin/sh
#PBS -l nodes=1:ppn=1,vmem=10G,walltime=48:00:00
#PBS -o train_VOC${PBS_ARRAYID}.log
#PBS -o train_VOC${PBS_ARRAYID}.err
cd $PBS_O_WORKDIR # Go to the directory the job was started in
matlab -singleCompThread -nojvm -nosplash -nodesktop -r "train_VOC(${PBS_ARRAYID}); quit;"