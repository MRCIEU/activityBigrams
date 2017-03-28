#!/bin/bash
#PBS -l walltime=1:00:00,nodes=1:ppn=6
#PBS -o output-gen-varsVD.file
#---------------------------------------------

module add apps/matlab-r2015a

cd /panfs/panasas01/sscm/lm0423/2016-alspac-accelerometer/activityBigrams/generateActivityVariables/

date

matlab -r "generateVariablesValidDaysOnly"

date


