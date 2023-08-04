#!/bin/bash
#PBS -l walltime=16:00:00
#PBS -N fmriprep-all
#PBS -q normal
#PBS -m bae
#PBS -M david.v.smith@temple.edu
#PBS -l nodes=12:ppn=4

# load modules and go to workdir
module load fsl/6.0.2
source $FSLDIR/etc/fslconf/fsl.sh
module load singularity/3.8.5
cd $PBS_O_WORKDIR
#echo "working in $PBS_O_WORKDIR with OMP_NUM_THREADS=$OMP_NUM_THREADS"

#export OMP_NUM_THREADS=7
# ensure paths are correct
maindir=~/work/rf1-mbme-pilot
scriptdir=$maindir/code
bidsdir=$maindir/bids
logdir=$maindir/logs
mkdir -p $logdir


rm -f $logdir/cmd_fmriprep_${PBS_JOBID}.txt
touch $logdir/cmd_fmriprep_${PBS_JOBID}.txt

# make derivatives folder if it doesn't exist.
# let's keep this out of bids for now
test=-02
if [ ! -d $maindir/derivatives$test ]; then
	mkdir -p $maindir/derivatives$test
fi

scratchdir=~/scratch/fmriprep$test
if [ ! -d $scratchdir ]; then
	mkdir -p $scratchdir
fi

TEMPLATEFLOW_DIR=~/work/tools/templateflow
MPLCONFIGDIR_DIR=~/work/mplconfigdir
export SINGULARITYENV_TEMPLATEFLOW_HOME=/opt/templateflow
export SINGULARITYENV_MPLCONFIGDIR=/opt/mplconfigdir

for sub in `ls -1d $bidsdir/sub-*`; do
#for sub in sub-10438 sub-10422 sub-10391; do
	sub="${sub##*/}"

	echo singularity run --cleanenv \
	-B ${TEMPLATEFLOW_DIR}:/opt/templateflow \
	-B ${MPLCONFIGDIR_DIR}:/opt/mplconfigdir \
	-B $maindir:/base \
	-B ~/work/tools/licenses:/opts \
	-B $scratchdir:/scratch \
	~/work/tools/fmriprep-22.0.2.simg \
	/base/bids /base/derivatives$test/fmriprep \
	participant --participant_label $sub \
	--stop-on-first-crash \
	--nthreads 12 \
	--me-output-echos \
	--stop-on-first-crash \
	--fs-no-reconall --fs-license-file /opts/fs_license.txt -w /scratch >> $logdir/cmd_fmriprep_${PBS_JOBID}.txt

done
# --nthreads 28 --omp-nthreads 7 \

torque-launch -p $logdir/chk_fmriprep_${PBS_JOBID}.txt $logdir/cmd_fmriprep_${PBS_JOBID}.txt
