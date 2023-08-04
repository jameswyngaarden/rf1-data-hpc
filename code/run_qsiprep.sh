#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

for sub in `cat ${scriptdir}/newsubs.txt` ; do

	script=${scriptdir}/fmriprep.sh
	NCORES=2 # need to do on OwlsNest with datalad since each sub has 8 runs of data with 4 echoes (needs 32 processors per sub)
	while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		sleep 5s
	done
	bash $script $sub &
	sleep 5s
	
done

