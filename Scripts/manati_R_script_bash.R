#!/usr/bin/env Rscript

#PBS -N my_first_script
#PBS -o /home/mcengic/script_output.txt
#PBS -e /home/mcengic/error_output.txt

print("Hola mundo")

user_name <- Sys.info()["user"]
current_date <- Sys.Date()

print(paste0("This is ", user_name, " reporting at ", current_date))