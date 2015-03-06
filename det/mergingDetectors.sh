#!/bin/sh
#PBS -l nodes=1:ppn=1,vmem=10G,walltime=30:00:00
#PBS -o mergingDetectors_${PBS_ARRAYID}.log
#PBS -o mergingDetectors_${PBS_ARRAYID}.err
cd $PBS_O_WORKDIR # Go to the directory the job was started in
matlab -singleCompThread -nojvm -nosplash -nodesktop -r "mergingDetectors(${PBS_ARRAYID}); quit;"