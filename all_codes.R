
folder_path <- "tmax"  # Path to your folder with .tiff files

# Get a list of all .tiff files in the folder
tmax_files <- list.files(path = folder_path, pattern = "\\.tif$", full.names = TRUE)

# Read all the .tiff files and stack them
library(terra)
tmax_stack <- rast(tmax_files)

# Calculate the mean across all raster layers
Tmax.mean <- mean(tmax_stack)
### THIS MAP NEEDS TO BE TRANSFORMED TO THE CELSIUS BEFORE USING

# Optionally, you can save the resulting mean raster to a new .tiff file
writeRaster(Tmax.mean, "tasmax10.tif", overwrite = TRUE)

# Plot the mean raster to check the result
plot(Tmax.mean)


# Set the path to the folder containing the .tiff files
folder_path_tmin <- "tmin"  # Path to your folder with .tiff files

# Get a list of all .tiff files in the folder
tmin_files <- list.files(path = folder_path_tmin, pattern = "\\.tif$", full.names = TRUE)

# Read all the .tiff files and stack them
tmin_stack <- rast(tmin_files)

# Calculate the mean across all raster layers
Tmin.mean <- mean(tmin_stack)
writeRaster(Tmin.mean, "tasmin10.tif", overwrite = TRUE)

# Set the path to the folder containing the .tiff files
folder_path_RH <- "RH"  # Path to your folder with .tiff files

# Get a list of all .tiff files in the folder
RH_files <- list.files(path = folder_path_RH, pattern = "\\.tif$", full.names = TRUE)

# Read all the .tiff files and stack them
RH_stack <- rast(RH_files)

# Calculate the mean across all raster layers
RH.mean <- mean(RH_stack)
writeRaster(RH.mean, "hurs10.tif", overwrite = TRUE)

# Set the path to the folder containing the .tiff files
folder_path_Pre <- "Prec"  # Path to your folder with .tiff files

# Get a list of all .tiff files in the folder
Pre_files <- list.files(path = folder_path_Pre, pattern = "\\.tif$", full.names = TRUE)

# Read all the .tiff files and stack them
Pre_stack <- rast(Pre_files)

# Calculate the mean across all raster layers
Pre.mean <- mean(Pre_stack)
writeRaster(Pre.mean, "precip10.tif", overwrite = TRUE)

# Set the path to the folder containing the .tiff files
folder_path_ct <- "Ctime"  # Path to your folder with .tiff files

# Get a list of all .tiff files in the folder
Ct_files <- list.files(path = folder_path_ct, pattern = "\\.tif$", full.names = TRUE)

# Read all the .tiff files and stack them
Ct_stack <- rast(Ct_files)

# Calculate the mean across all raster layers
Ct.mean <- mean(Ct_stack)
writeRaster(Ct.mean, "Ctime10.tif", overwrite = TRUE)

# Load the rasters
## Rice datasets in Asia
## https://doi.org/10.3390/rs14174189
## https://doi.org/10.1016/j.agsy.2022.103437
## https://zenodo.org/records/5555717
rice.rast<-rast("cropIntensity2021.tif")
plot(rice.rast, main = "Rice cropping intensity 2021")
plot(countries, add = T, border = "grey80", lwd = 1.5)

values(rice.rast)<-ifelse(values(rice.rast)>0, 
                          values(rice.rast),NaN)
SEA.ext<-ext(rice.rast)

library(rnaturalearth)
countries <- vect(ne_countries(scale = "medium", returnclass = "sf"))

Tmin.temp <- rast("tasmin10.tif")
Tmin.temp<-crop(Tmin.temp,SEA.ext)
Tmin.temp <- Tmin.temp * 0.1 - 273.15 # Celsius
plot(Tmin.temp)

Tmax.temp <- rast("tasmax10.tif")
Tmax.temp<-crop(Tmax.temp,SEA.ext)
Tmax.temp <- Tmax.temp * 0.1 - 273.15 # Celsius
plot(Tmax.temp)

Precip <- rast("precip10.tif") # Monthly precipitation amount
Precip <- crop(Precip,SEA.ext)
Precip <- Precip / 100 # kg m-2 month-1
plot(Precip, main = "Precipitation (mm/month)")

RH <- rast("hurs10.tif") # Monthly nearsurface relative humidity
RH <- crop(RH,SEA.ext)
#RH <- RH * 0.01 # % #not convert since it is already in percentage
plot(RH)

Ct <- rast("Ctime10.tif") #Cloud cover in %
plot(Ct)

# Pathogen's ranges (based on literature)
Tmin.pathogen <- 18 #initially set at 18
Tmax.pathogen <- 32 #initially set at 29
empty.rast <- RH
values(empty.rast)<- -999
Tsuitability <- empty.rast
values(Tsuitability)<-ifelse(values(Tmin.temp)<Tmin.pathogen | values(Tmax.temp)>Tmax.pathogen, 0,
                             values(Tmax.temp) - values(Tmin.temp))
maxi.temp<-max(values(Tsuitability), na.rm = TRUE)
Tsuitability<-Tsuitability / maxi.temp * 100
  
plot(Tsuitability, main = "Temperature tolerated by pathogen")
plot(countries, add = T, border = "grey50", lwd = 0.75)

min.rh.pathogen <- 60 #initially set at 75
max.rh.pathogen <- 100 #initially set at 90
RHsuitability <- empty.rast
values(RHsuitability)<-ifelse(values(RH)>max.rh.pathogen | values(RH)<min.rh.pathogen, 0,
                              max.rh.pathogen - values(RH))
maxi.rh<-max(values(RHsuitability), na.rm = TRUE)
RHsuitability <- RHsuitability / maxi.rh * 100

plot(RHsuitability, main = "Relative humidity tolerated by pathogen")
plot(countries, add = T, border = "grey50", lwd = 0.75)

#Which are the units for precipitation? mm/month?
min.prep.pathogen <- 200 #initially set at 2
max.prep.pathogen <- 700 #initially set at 7

prep.suitability <- empty.rast
values(prep.suitability)<-ifelse(values(Precip)>max.prep.pathogen | values(Precip)<min.prep.pathogen, 0,
                              max.prep.pathogen - values(Precip))
maxi.prep<-max(values(prep.suitability), na.rm = TRUE)
prep.suitability <- prep.suitability / maxi.prep * 100

plot(prep.suitability, main = "Precipitation suitable for the pathogen")
plot(countries, add = T, border = "grey50", lwd = 0.75)

# Sunlight in hours per day
min.sun.pathogen <- 3
max.sun.pathogen <- 6

# Combined suitability for the pathogen
comb.suitability<-mean(Tsuitability,RHsuitability,prep.suitability)
values(comb.suitability)<-ifelse(values(comb.suitability)>0,
                                 values(comb.suitability), NaN)
comb.suitability<-mask(comb.suitability, countries)

plot(comb.suitability, main = "Combined suitability")
plot(countries, add = T, border = "grey80", lwd = 1.5)

comb.suitability<-resample(comb.suitability, rice.rast)
comb.suitability1<- comb.suitability * rice.rast

library(RColorBrewer)
library(viridis)
beauty.palette <- colorRampPalette(rev(brewer.pal(11, "Spectral")),space="Lab")
vir.rich<-viridis(n=100, option = "inferno", begin = 0.05)

plot(comb.suitability1, col = beauty.palette(100),
     main = "Climate suitability (%) + Rice intensity (?)")
plot(countries, add = T, border = "grey80", lwd = 1)

# Calculate sun hours (assuming 12 hours in a day)
sun_raster <- 12 - Ct_raster
