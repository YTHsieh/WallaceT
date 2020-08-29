##使用R version: 4.0.2

##初次使用時安裝.
###----------1. Check the environment.---------------------------###
source("setup.R")
## 自動檢查R package的環境，如果不符合開發時package-
## 的版本，則自動重新安裝對應版本.

## 如果上面的安裝無法正確進行，請執行下方code。
# install.packages('wallace')

###----------------------------------------------------------###

##-----------2. Set parameters.---------------------------##
target_raster <- "20200809_Trocho-_L_3_proj-extent_2.5.tif"
## 設定欲讀入的geotiff檔名。

plot_title <- ""
## 如果不設定此項，則不會顯示圖片上方的標題。

breaks <-  c(0.0001, 0.0002, 0.0005, 0.0010)
## 自訂色階分級。

palette <- "BuRdTheme"
#### 選擇要使用的色板：
  ## 1. rasterTheme (default) (紫色-亮黃色)
  ## 2. RdBuTheme (紅色-藍色)
  ## 3. BuRdTheme (藍色-紅色)
  ## 4. GrTheme (黑色-白色)
  ## 5. BTCTheme (深藍色-白色)
  ## 6. PuOrTheme (紫色-橘色)。

Image_Name <- "test0813"
## 設定要儲存的圖片檔名。
###----------------------------------------------------------###

##-----------3. Load required packages.----------------------------------------##

# load the package
library(wallace)
library(raster)
library(rasterVis)

# Optional install for jcolors palettee, which is another good choice of visualization.
# install.packages("viridis")
library(viridis)

# Optional load for country boundary download from GADM.
library(GADMTools)
library(rnaturalearth)
library(rnaturalearthdata)
##---------------------------------------------------##

##----------4. Run Wallace to model the distribution of certain species.---------------------------##
# run the app
run_wallace()

##---------------------------------------------------##

##----------5. R繪圖測試區。---------------------------##

# 讀入下載好的物種分布模型圖檔，檔名須為.tif。
raster_filepath <- paste(getwd(), "Outputs", target_raster, sep = "/")
new_raster <-  raster(raster_filepath)

# 請執行任一行，建議執行最末行。
# 使用Rbase的plot()函數繪圖。
p <- plot(new_raster, 
          col = viridis_pal(direction = 1, option = "A")(100))

# 使用package: rasterVis 來繪圖。

p <- rasterVis::levelplot(new_raster); p
## 完全使用預設值。

p <- rasterVis::levelplot(new_raster, zscaleLog = TRUE, contour = TRUE); p
## 將色階進行log轉換，並繪出等高線。

p <- rasterVis::levelplot(new_raster, contour = FALSE, margin = FALSE, main = plot_title); p
## 如果想令電腦自動設定色階，請執行此行。

p <- rasterVis::levelplot(new_raster, contour = FALSE, margin = FALSE, main = plot_title, at = breaks); p
## 如果想自訂色階，請執行此行。

p <- rasterVis::levelplot(new_raster, contour = FALSE, margin = FALSE, main = plot_title, par.settings = palette); p
## 依設定的色板繪圖。
##---------------------------------------------------##

##--------------6. 繪圖存檔設定。---------------##
## Tiff檔

Image_Tiff <- paste(Image_Name, ".tiff", sep = "")
tiff(paste(getwd(), "Outputs", Image_Tiff, sep = "/"), units="in", width=5, height=5, res=300)
## Turn on the saving board for the thematic map.

p
## 出圖。

dev.off()
## Turn off the saving board. 

## PNG檔

Image_PNG <- paste(Image_Name, ".png", sep = "")
png(paste(getwd(), "Outputs", Image_PNG, sep = "/"), units="in", width=5, height=5, res=300)
## Turn on the saving board for the thematic map.

p
## 出圖。

dev.off()
## Turn off the saving board. 

##------------------------------------------------##

##--------------Extra-plus 繪上行政區界線。---------------##
#如果想為繪出的圖加上行政區界，請擇一執行以下block後，再次執行"6."。

### 1. 加上臺灣或是特定國家的行政區界。
map <- gadm_sf_loadCountries("TWN", level = 2, basefile = "./Inputs/")
## 透過R，直接從GADM database下載並載入TW縣市界，存成class-"gadm_sf".
##預設為「臺灣」，若想更改請修改第一格國碼，詳細資料請查閱GADM官網: https://gadm.org/ 。 

boundary <- map$sf
## 抽出行政區界的sf內容。

st_crs(boundary) = 4326
## 設定crs。

boundary_sp <- as_Spatial(boundary)
## 將 object: sf 轉換成 object: SpatialPolygonsDataFrame。

p <- p + layer(sp.lines(boundary_sp, lwd=1, col='black'))
## 重設p的圖層

### 2. 加上區域內的國家區界。
##使用package: rnaturalearth, rnaturalearthdata.
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)
st_crs(world) = 4326
world_sp <- as_Spatial(world)
p <- p + layer(sp.lines(world_sp, lwd=1, col='black'))
##------------------------------------------------##

##----------------Extra-plus 把兩圖放在一起比較。---------------##

plot_extent <- raster::extent(118, 125, 20, 30)
## 請設定一邊界完整涵蓋原圖範圍。

empty_raster <- raster(plot_extent)
## 根據object: plot_extent建立空網格。

empty_raster@crs <- CRS(SRS_string= "EPSG:4326")
## 設定空網格的CRS，與目標網格相同。
res(empty_raster) <- res(new_raster)
## 設定空網格的解析度，與目標網格相同。

m1 <- raster::merge(empty_raster, new_raster, filename= paste(getwd(), "Outputs", "test_merge.grd", sep = "/"), overwrite=TRUE)
## 將空網格與目標網格融合，其目的為增加網格的範圍。

target_raster2 <- "20200809_Trocho-_L_3_proj-time_2.5.tif"
## 設定第二個geotiff檔的檔名。

raster_filepath2 <- paste(getwd(), "Outputs", target_raster2, sep = "/")
new_raster2 <-  raster(raster_filepath2)
## 讀入第二個圖檔，檔名須為.tiff。

plot_A_crop <- raster::crop(m1, new_raster2@extent)
## 根據第二個Raster，裁減第一個Raster。

plot_S <- stack(plot_A_crop, new_raster2)
## 將兩個raster疊加起來。
names(plot_S) <- c("A","B")
## 設定兩圖於圖板的名稱

p2 <- rasterVis::levelplot(plot_S, contour = FALSE, margin = FALSE, main = plot_title, par.settings = palette); p2
## 照模板出圖。
p2 <- p2 + layer(sp.lines(world_sp, lwd=1, col='black')); p2
## 重疊上行政區界。
## 若是只加上台灣的行政區界，請使用下面code。
## p2 <- p2 + layer(sp.lines(boundary_sp, lwd=1, col='black')); p2

pA <- rasterVis::levelplot(plot_A_crop, contour = FALSE, margin = FALSE, main = plot_title, par.settings = palette); pA
## 單獨輸出相同座標的A圖。
## 如果想要兩圖有相同的色階圖例，可以設定"breaks"參數，並於上面多加上", at = breaks"。

##------------------------------------------------##