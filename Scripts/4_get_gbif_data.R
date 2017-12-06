library(spocc)
library(sp)

# Create bounding box for Peru
bbox_peru <- c(-82.6, -67.4, -20.2, 1.8)

# Get species data
c_cornuta <- occ(query = "Ceratophrys cornuta", from = "gbif", geometry = bbox_peru,
           has_coords = TRUE)
c_cornuta

class(c_cornuta)


c_cornuta_df <- occ2df(c_cornuta)

str(c_cornuta_df)

library(sp)
library(raster)

coordinates(c_cornuta_df) <- ~ longitude+latitude 
proj4string(c_cornuta_df) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
plot(c_cornuta_df)

library(mapview)
mapview(c_cornuta_df)
####
library(redlistr)
# Create etent of occurence
c_cornuta_raster <- rasterFromXYZ(c_cornuta_df)
plot(c_cornuta_raster)

species_eoo <- makeEOO(r_inca_raster)
mapview(species_eoo)
getAreaEOO(species_eoo)