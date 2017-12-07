print("Hola mundo")

user_name <- Sys.info()["user"]
current_date <- Sys.Date()

print(paste0("This is ", user_name, " reporting at ", current_date))