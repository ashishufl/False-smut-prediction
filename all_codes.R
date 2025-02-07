
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

##### more code available on request#####
