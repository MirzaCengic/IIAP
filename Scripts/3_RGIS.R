##%######################################################%##
#                                                          #
####      Introduction to spatial data analysis in      ####
####       R # Mirza Cengic | mirzaceng@gmail.com       ####
#                                                          #
##%######################################################%##
library(rgdal)
library(raster)
library(sp)
library(sf)

# Download data with getData() function
# Because it can be too much for 30 people to download this simultaneosly, we will load it from USB
# peru <- getData("GADM", country = "PE", level = 3)

# Modify path - set working directory
setwd()
# Load shapefile into R
# You can also use:
# file.choose()
peru <- shapefile("E:/IIAP/IIAP_workshop/Resources_USB/Data/Peru/Administrative/Peru_adm3.shp")

peru

plot(peru)
mapview(peru)

peru_roads <- shapefile("E:/IIAP/IIAP_workshop/Resources_USB/Data/Peru/Roads/PER_roads.shp")


# Load single raster
peru_DEM <- raster("E:\\IIAP\\IIAP_workshop\\Resources_USB\\Data\\Peru\\DEM\\PER_alt.grd")

# plot
plot(peru_DEM)
# Plot with rastervis
library(rasterVis)
levelplot(peru_DEM)
# interactive plotting
mapview(peru_DEM)

# Load rasterstack
current_climate_files <- list.files("E:/IIAP/IIAP_workshop/Resources_USB/Data/Climate/Current/bio_5m_bil/", pattern = "bil$", full.names = TRUE)
current_climate_stack <- stack(current_climate_files)

writeFormats()
# Operations on rasters (mean, max, sd)
# Subsetting rasters with [[]]biolcim
plot(current_climate_stack)

# Vectors
# loading with sp

peru_sp <- shapefile("E:/IIAP/IIAP_workshop/Resources_USB/Data/Peru/Administrative/Peru_adm3.shp")
peru_sp

# loading with sf
peru_sf <- st_read("E:/IIAP/IIAP_workshop/Resources_USB/Data/Peru/Administrative/Peru_adm3.shp")

peru_sf

# Converting between sf and sp
as(peru_sf, "Spatial")
st_as_sf(peru_sp)

# Changing coordinate system
browseURL("http://spatialreference.org/")

## Reprojecting for different spatial data types
# Raster
projectRaster(peru_DEM)
# sp
spTransform(peru_sp, CRSobj = )
# sf
st_transform(peru_sf, crs = 4326)

# Using pipes with sf

peru_country <- peru_sf %>% 
  st_union()
plot(peru_country)

# Dissolve to district level
peru_district <- peru_sf %>% 
  group_by(NAME_1) %>% 
  summarise() 

peru_region <- peru_sf %>% 
  group_by(NAME_2) %>% 
  summarise() 





# Combining rasters and vectors
peru_DEM_crop <- crop(peru_DEM, peru)
peru_DEM_mask <- mask(peru_DEM, peru)

# Get annual mean temperature for each district in Peru
peru_amt <- extract(peru_bioclim[[1]], peru_district_sp, fun = mean, sp = TRUE)

# Use tmap to create thematic map
library(tmap)

tm_shape(peru_bioclim[[1]]) +
  tm_raster(legend.show	= FALSE) +
  tm_shape(peru_district) +
  tm_borders() +
  tm_facets("NAME_1") +
  tm_shape(peru_amt) +
  tm_bubbles("bio1", "red") +
  tm_style_natural() +
  tm_legend(position = c("left", "bottom")) +
  tm_facets()



## Create terrain variables
# Create slope
peru_slope <- terrain(peru_DEM, opt= "slope")
# Create aspect
peru_aspect <- terrain(peru_DEM, opt = "aspect")
# Since aspect has circular distribution, create variable with normal distribution (northness)
peru_northness <- cos(peru_aspect)

# Rasterize roads layer (might take time)
peru_roads_r <- rasterize(peru_roads, peru_DEM)
# Calculate distance from roads (might take time)
peru_distance_roads <- distance(peru_roads_r)

writeRaster()