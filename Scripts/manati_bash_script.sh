#! /bin/bash

#PBS -N my_first_bash_script
#PBS -o /home/mcengic/script_output.txt
#PBS -e /home/mcengic/error_output.txt

Rscript /home/mcengic/manati_R_script.R

echo "It works!"
