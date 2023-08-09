#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -N tedana-all
#PBS -q normal
#PBS -m ae
#PBS -M david.v.smith@temple.edu
#PBS -l nodes=12:ppn=28

# load modules and go to workdir
module load fsl/6.0.2
source $FSLDIR/etc/fslconf/fsl.sh
module load singularity/3.8.5
cd $PBS_O_WORKDIR

# ensure paths are correct
maindir=~/work/rf1-data-hpc #this should be the only line that has to change if the rest of the script is set up correctly
scriptdir=$maindir/code
bidsdir=$maindir/bids
logdir=$maindir/logs
mkdir -p $logdir


rm -f $logdir/cmd_tedana_${PBS_JOBID}.txt
touch $logdir/cmd_tedana_${PBS_JOBID}.txt

# need to change this to a more targetted list of subjects
for sub in `ls -1d $bidsdir/sub-*`; do
	sub=${sub:(-5)}
	for task in socialdoors doors trust sharedreward ugr; do
		for run in 1 2; do

			echo python tedana-single.py \
			--fmriprepDir $maindir/derivatives/fmriprep \
			--bidsDir $bidsdir \
			--sub $sub \
			--task $task \
			--runnum $run >> $logdir/cmd_tedana_${PBS_JOBID}.txt

		done
	done
done

torque-launch -p $logdir/chk_tedana_${PBS_JOBID}.txt $logdir/cmd_tedana_${PBS_JOBID}.txt
