#!/usr/bin/env python

import json
import os
import re
import pandas as pd
from tedana import workflows
import time
import argparse

parser = argparse.ArgumentParser(description='Give me a path to your inputs.')
parser.add_argument('--fmriprepDir',default=None, type=str, help="This is the full path to your fmriprep dir")
parser.add_argument('--bidsDir',default=None, type=str, help="This is the full path to your BIDS directory")
parser.add_argument('--sub',default=None, type=int, help="This is the subject number.")
parser.add_argument('--task',default=None, type=str, help="This is the task.")
parser.add_argument('--runnum',default=None, type=int, help="This is the run number.")

args = parser.parse_args()

prep_data = args.fmriprepDir
bids_dir = args.bidsDir
sub = args.sub
task = args.task
runnum = args.runnum

prefix = "sub-{}_task-{}_run-{}".format(str(sub),task,str(runnum))
print(prefix)

def RUN_Tedana(sub,prefix,EchoFiles,EchoTimes,OutDir):
       os.makedirs(OutDir,exist_ok=True)
       print("Running TEDANA for sub-%d_task-%s_run-%d "%(sub, task, runnum)+'\n')

       workflows.tedana_workflow(
       EchoFiles,
	   EchoTimes,
	   out_dir=OutDir,
	   prefix="%s"%(prefix),
	   fittype="curvefit",
	   tedpca="kic",
	   verbose=True,
	   gscontrol=None)


ME_headerinfo=[os.path.join(root, f) for root, dirs, files in os.walk(bids_dir) for f in files
               if (prefix in f) & (f.endswith('_bold.json'))]
echo_times=[json.load(open(f))['EchoTime'] for f in ME_headerinfo]
echo_times.sort()

task_image_files=[os.path.join(root, f) for root, dirs, files in os.walk(prep_data) for f in files
              if (prefix in f) & ('echo' in f) & (f.endswith('_desc-preproc_bold.nii.gz'))]
task_image_files.sort()


out_dir= os.path.join(os.path.abspath(os.path.dirname( prep_data )), "tedana/%s/%s"%(sub,prefix))

RUN_Tedana(sub,prefix,acq_image_files,echo_times,out_dir)
