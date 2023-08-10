# Using Temple's OwlsNest
Temple has a High Performance Computing cluster and one specific aspect that is relevant to our lab is the [OwlsNest](https://www.hpc.temple.edu/owlsnest2/). It will help us process our neuroimaging data much more quickly than we can do on our local resources. This resource is especially useful for the data coming in off our RF1 grant since it uses mulit-echo fMRI and benefits from `mriqc`, `fmriprep`, `qsiprep`, and `tedana`. You can also run tons of `feat` jobs relatively easily

Eventually, we might be able to effectively use other resources tied to their GPU systems, but these systems only work for DWI analyses right now.

In all use cases, the biggest thing to keep in mind is efficient use of the resources (more on this below). In a nutshell, you need to have a good sense of how many CPUs and how much memory you need when you submit jobs (a.k.a. tasks) to an HPC. Don't request more resources than you need, but don't request too few.

## What should you know already before using the OwlsNest?
Before you start playing around on the OwlsNest, you should be quite comfortable with Linux and using the command line for any tasks. You should also read through the documentation for the OwlsNest and especially job submission. This page assumes you have read their documentation and have a basic sense of the available resources and how to submit jobs.

If you're not quite comfortable with Linux and the command line, here are a few recommendations to help get you up to speed:
1. FSL course materials. See [Introduction to Unix](https://open.win.ox.ac.uk/pages/fslcourse/website/online_materials.html)
2. ReproNim materials. See [Command line / shell](http://www.repronim.org/module-reproducible-basics/01-shell-basics/) module.
3. The first five tutorials from this [University of Surrey site](http://www.ee.surrey.ac.uk/Teaching/Unix/).

Beyond basic operations in Linux, you should also have a good sense of how much resources your jobs require. This point is worth the redundancy, and more guidance is below.

## Summary of basic steps
1. Copy data from the Smith Lab Linux to your work directory on the OwlsNest.
2. scripts

## Examples and notes


## Things to consider
Using the OwlsNest effectively is still a work in progress
- Memory allocation is something you have to think about depending on what you're doing. In general, jobs using `feat` (e.g., our `L1stats-hpc.sh` script) need much less memory than `fmriprep`.
- Submission process may be changing to SLURM soon, which is likely good since it's what most folks in our field already use.
- Need to be careful using `rsync` to copy files back and forth between the OwlsNest and our Linux Box. You can choose to only sync new files (e.g., try `--ignore-existing`; see [this page](https://unix.stackexchange.com/questions/67539/how-to-rsync-only-new-files) for more information)
