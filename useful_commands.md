# Some useful commands
## Some useful linux command
  - **ls** - list files
  - **ls -l** - list files (long format)
  - **cd** - change directory
  - **cd ..** - go one directory back
  - **mkdir** - make directory 
  - **mv** - move file
  - **cp** - copy file
  - **rm** - remove file
  - **who** - see who's logged in
  
## Useful PBS commands
  - **qsub** - submit a job
  - **qdel** - delete a job
  - **qstat** - show batch jobs
  - **pbsnodes** - show status of nodes
  - **xpbsmon** - interactive gui of node states
  
# .bashrc content
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export PATH=/opt/shared/R-3.4.2/bin:$PATH

export GDAL_HOME=/opt/shared/gdal-2.2.2