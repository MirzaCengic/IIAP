library(sp)

atra_loc <- read.csv()


head(atra_loc)



coordinates(atra_loc)<-~Y+X

proj4string(atra_loc) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

library(raster)

library(usdm)
# Calculate multicollinearity
bih_rasters <- stack(list.files("E:/IIAP/IIAP_workshop/Resources_USB/Data/Sal_atra/Bioclim/", full.names = T))

vif_values <- vifstep(bih_rasters, th = 10)
exclude(bih_rasters, vif_values)

# Za R je napravljeno više paketa za SDM (Species Distribution Modelling). 
# Jedan od paketa je biomod2 kojeg ćemo danas koristiti. Biomod2 ima 10 različitih statističih metoda za modelovanje. 
#

library(biomod2)

# Set biomod options
BiomodOptions <- BIOMOD_ModelingOptions()

# Prepare modeling data
Atra_modeling_data <- BIOMOD_FormatingData(resp.var = rep(1, length(atra_loc$Subspecies)), expl.var = BiH_rasters_subset,
                                           resp.xy = atra_loc@coords, eval.resp.xy = NULL,
                                           PA.nb.rep = 2, 
                                           PA.nb.absences = 1000,
                                           PA.strategy = 'random', na.rm = TRUE, resp.name = "Sal_atra")

# Fit models using GLM (try other methods if you don't mind waiting, or if you want to try ensemble models)
Atra_model_out <- BIOMOD_Modeling(Atra_modeling_data, models = "GLM", models.options = BiomodOptions, NbRunEval=2, 
                                  DataSplit=80, VarImport=10, models.eval.meth = c("TSS","ROC"),
                                  SaveObj = FALSE, rescal.all.models = TRUE, do.full.models = FALSE,
                                  modeling.id = "Sal_atra_GLM")


# Project models into geographic space
Atra_model_projection <- BIOMOD_Projection(modeling.output = Atra_model_out, new.env = BiH_rasters_subset, proj.name = "current", 
                                           selected.models = "all", binary.meth = "TSS", compress = "xz",
                                           build.clamping.mask = FALSE, output.format = ".img")

# ----------------------------------------------------------------------------------------------------------------------


#

eval_values_em <- myBiomodEM %>% 
  get_evaluations() %>%
  as.data.frame() %>%
  select(contains("Testing.data")) %>%
  mutate(Var = row.names(.)) %>% 
  select(Var, everything())

# Get model evaluation and variable importance
write.csv(eval_values_em, "Model_assessment.csv", 
          row.names = FALSE)

var_imp_values_em <- myBiomodEM %>% 
  get_variables_importance() %>% 
  as.data.frame() %>%
  mutate(Var = row.names(.)) %>% 
  select(Var, everything())

write.csv(var_imp_values_em, "Variable_importance.csv", 
          row.names = FALSE)

plot(Atra_model_projection)

# Calculate mean of many projections
Atra_model_mean <- mean(Atra_model_projection@proj@val)

plot(Atra_model_mean)

# Divide by 1000 to get values from 0 - 1
Atra_model_mean <- Atra_model_mean/1000
plot(Atra_model_mean)

Atra_model_mean[Atra_model_mean < 0.1] <- NA

# Prikaz granice i originalnih tačaka
plot(Atra_model_mean)
plot(BiH_boundary, add = TRUE)
plot(atra_loc, add = TRUE)

# Spašavanje mape kao kml file kojeg je moguće otvoriti u Google Earthu
KML(Atra_model_mean, file = "Atra_niche.kml", overwrite = TRUE)

# Create webmap with leaflet
# install.packages("leaflet")
library(leaflet)

# Create color pallete
pal <- colorNumeric(c("#FFFFCC", "#e9a3c9", "#af8dc3"), values(Atra_model_mean),
                    na.color = "transparent")

atra_leaflet_map <- leaflet() %>% addTiles() %>%
  addRasterImage(Atra_model_mean, colors = pal, opacity = 0.7) %>%
  addLegend(pal = pal, values = values(Atra_model_mean),
            title = "Value")

atra_leaflet_map

# Save map to html
install.packages("htmlwidgets")
library(htmlwidgets)
saveWidget(atra_leaflet_map, file="Atra_leaflet_map.html")

# or do the same with mapview
mapview()
mapshot()