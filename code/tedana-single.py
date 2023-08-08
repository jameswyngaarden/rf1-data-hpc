#!/usr/bin/env python
# coding: utf-8

# In[1]:


import json
import os
import re

import pandas as pd
from tedana import workflows
import time

import argparse

parser = argparse.ArgumentParser(
    description='Give me a path to your fmriprep output and number of cores to run')
parser.add_argument('--fmriprepDir',default=None, type=str,help="This is the full path to your fmriprep dir")
parser.add_argument('--bidsDir',default=None, type=str,help="This is the full path to your BIDS directory")
parser.add_argument('-sub',default=None, type=int,help="This is the subjectnumber please format with 'sub-###'")
parser.add_argument('-acq',default=None, type=int,help="This is the acquistion please format with 'acq-###'")

args = parser.parse_args()
#inputs

prep_data = args.fmriprepDir
bids_dir=args.bidsDir
sub=args.sub
acq=args.acq

#
def RUN_Tedana(sub,prefix,EchoFiles,EchoTimes,OutDir):

    
    #time.sleep(2)
    #print(sub,acq+'\n')
    
    if os.path.exists("%s/%s_desc-optcomDenoised_bold.nii.gz "%(OutDir,acq)):
        print('Tedana was previously run for Sub %s acq- %s remove directory if they need to be reanalyzed'%(sub,acq))
    else:
  
        os.makedirs(OutDir,exist_ok=True)
        print("Running TEDANA for %s %s"%(sub, acq)+'\n')
        
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
               if (acq in f)& (f.endswith('_bold.json'))]
echo_times=[json.load(open(f))['EchoTime'] for f in ME_headerinfo]
echo_times.sort()
         
acq_image_files=[os.path.join(root, f) for root, dirs, files in os.walk(prep_data) for f in files
              if (acq in f) & ('echo' in f) & (f.endswith('_desc-preproc_bold.nii.gz'))]
acq_image_files.sort()
# # Obtain Echo files


out_dir= os.path.join(os.path.abspath(os.path.dirname( prep_data )), "tedana/%s/%s"%(sub,acq))
            
RUN_Tedana(sub,acq,acq_image_files,echo_times,out_dir):

    




