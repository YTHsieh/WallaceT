##使用R version: 4.0.2

#安裝並載入package: devtools.
install.packages("devtools")
library(devtools)


###----------Check the environment---------------------------###

# 存取所有已安裝packages.
Packages <- installed.packages()
Packages <- as.data.frame(Packages[, 1])
rownames(Packages) <- c()
colnames(Packages) <- c("Package")

#Packages <- installed.packages() %>% 
#  as.data.frame() %>% 
#  dplyr::select(Package)
#rownames(Packages) <- c()
## 去除rownames.

Needed_Packages <- list(
  sf = c("sf", "0.9.4"),
  raster = c("raster", "3.1-5"),
  dplyr = c("dplyr", "1.0.0"),
  sdm = c("sdm", "1.0-89"),
  usdm = c("usdm", "1.1-18"),
  dismo = c("dismo", "1.1-4"),
  mapview = c("mapview", "2.7.8"),
  shiny = c("shiny", "1.5.0"),
  rJava = c("rJava", "0.9-13"),
  wallace = c("wallace", "1.0.6.2"),
  rasterVis = c("rasterVis", "0.48"),
  GADMTools = c("GADMTools", "3.8-1"),
  rnaturalearth = c("rnaturalearth", "0.1.0"),
  rnaturalearthdata = c("rnaturalearthdata", "0.1.0")
)
## 建立需要的packages的list.


# 確認各package的版本是否正確，若無或有缺漏則安裝正確版本的packages.
for (i in 1:length(Needed_Packages)) {
  name <- Needed_Packages[[i]][1]
  version <- Needed_Packages[[i]][2]
  
  TRY <- try(packageVersion(name) != version)
  
  if (is.logical(TRY) == TRUE) {
    if (packageVersion(name) != version) {
      if (length(which(Packages == name)) == 1) {
        remove.packages(name)
        install_version(name, version = version, repos = "http://cran.us.r-project.org")
        }else{
        install_version(name, version = version, repos = "http://cran.us.r-project.org")  
        }
      }else{
      }
    }else{
      install_version(name, version = version, repos = "http://cran.us.r-project.org")  
    }
}

###---------------------------------------------------###