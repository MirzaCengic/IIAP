##%######################################################%##
#                                                          #
####                   Profiling code                   ####
#                                                          #
##%######################################################%##

# For measuring execution time of function or code section
library(tictoc)
# Measure and compare functions
library(microbenchmark)
# Profile user functions
library(aprof)

# system.time
system.time(Sys.sleep(3))

# Sys.time
now <- Sys.time()
Sys.sleep(3)
Sys.time() - now

# tictoc
tic("Three seconds")
Sys.sleep(3)
toc()

# Microbenchmark example
microbenchmark(
  Sys.sleep(0.1),
  Sys.sleep(0.2),
  Sys.sleep(0.3),
  times = 10
)



# Loops, vectorisation, apply ---------------------------------------------

random_numbers <- rnorm(100000)
null_data <- rep(NA, length(random_numbers))

# Processing every element of an object with for loop
tic("For loop")
for (i in seq_along(random_numbers)){
  null_data[i] <- random_numbers[i] + 1
}
toc()

# Using vectorized functions for same
tic("Vectorized")
null_data <- random_numbers + 1
toc()

## Calculating mean value across object
mtcars
mtcars_col_means <- rep(NA, ncol(mtcars))

# For loop
tic("For loop")
for (i in 1:ncol(mtcars)){
  mtcars_col_means[i] <- mean(mtcars[, i])
}
toc()
# Apply
tic("Apply")
mtcars_col_means <- apply(mtcars, 2, mean)
toc()
# Vectorized 
tic("Vectorized")
mtcars_col_means <- colMeans(mtcars)
toc()

# Microbenchmark
microbenchmark(
  for (i in 1:ncol(mtcars)){mtcars_col_means[i] <- mean(mtcars[, i])},
  apply(mtcars, 2, mean),
  colMeans(mtcars),
  times = 10
)

# Rcpp
# "E:/IIAP/IIAP_workshop/R/Functions/cp_functions.cpp"
# library(Rcpp)
# cppFunction("E:/IIAP/IIAP_workshop/R/Functions/cp_functions.cpp")


# Profile get_changes -----------------------------------------------------
library(raster)
ro_stack <- stack("E:/IIAP/IIAP_workshop/Data_temp/changes_presentation/lc_layer_2005.tif",
                  "E:/IIAP/IIAP_workshop/Data_temp/changes_presentation/lc_layer_2015.tif")


plot(ro_stack)

crops_category <- 10:40

####
vals <- getValues(ro_stack)
"%notin%" <- Negate("%in%")
no_crop_index <- which(vals[, 2] %notin% crops_category)


# Check which values aren't crops
no_crop_index_ifelse <- ifelse(vals[, 2] %notin% crops_category, NA, 1)

# Convert to NA
# Forest loss and crops gain
vals[no_crop_index, ] <- NA

# binarize changes
is_change <- ifelse(vals[, 1] == vals[, 2], NA, 1)
ro_diff_negate <- setValues(ro_stack[[2]], is_change)

plot(ro_diff_negate)

iq_crops_pts <- rasterToPoints(ro_diff_negate, sp = TRUE)
plot(iq_crops_pts)
mapview::mapview(ro_diff_negate)

# For iquitos region
vals <- getValues(iq_stack)
# Check which values aren't crops
no_forest_index <- which(vals[, 1] %in% 10:220)
no_crop_index <- which(vals[, 2] %notin% crops_category)

# Convert to NA
# Forest loss and crops gain
vals[no_forest_index, ] <- NA
vals[no_crop_index, ] <- NA
# binarize changes
is_change <- ifelse(vals[, 1] == vals[, 2], NA, 1)
iq_diff_negate <- setValues(iq_stack[[2]], is_change)

mapview(iq_diff_negate)


plot(iq_diff_negate)

iq_crops_pts <- rasterToPoints(iq_diff_negate, sp = TRUE)
plot(iq_crops_pts)
mapview(iq_diff_negate)


# Profiling get changes function ------------------------------------------

# Profile old one 
source("E:/IIAP/IIAP_workshop/R/Functions/get_change_raster_old.R")
tmp_file <- tempfile()
Rprof(tmp_file, line.profiling = TRUE)

get_change_raster_old(ro_stack, "E:/IIAP/diff_delete_old.tif", category = 10:40)
Rprof(append = FALSE)
profile_old <- aprof("E:/IIAP/IIAP_workshop/R/Functions/get_change_raster_old.R", tmp_file)
plot(profile_old)


source("E:/IIAP/IIAP_workshop/R/Functions/get_change_raster.R")

tmp_file <- tempfile()
Rprof(tmp_file, line.profiling = TRUE)

get_change_raster(ro_stack, "E:/IIAP/diff_delete.tif", category = 10:40)
Rprof(append = FALSE)
profile_new <- aprof("E:/IIAP/IIAP_workshop/R/Functions/get_change_raster.R", tmp_file)
plot(profile_new)

# 
