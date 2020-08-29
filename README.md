---
title: 'Wallace使用指南'
disqus: hackmd
---

Wallace使用指南
===

## Table of Contents

[TOC]

## 專案介紹

本指南的目的是引導讀者進行物種分布模型的建立 (又可稱為物種的「生態棲位模擬」)，並將結果出圖呈現。我們使用的平台為R語言，此為在生態、演化領域被廣為使用的程式語言，透過程式語言進行模型配適，我們可以完全重現每一次的分析過程，並且可以將需要重複進行的步驟交由電腦自動完成，將寶貴的時間省下來檢視更為重要的研究細節。

利用R配適物種分布模型的方式眾多，也有許多前輩將常用的指令稿整理成數個package。我們將要分別使用「Wallace」進行模型配適，及「rasterVis」來視覺化分析結果。

[Wallace](https://wallaceecomod.github.io/)是一個R-based的彈性化的物種分布模型建立框架 (原文為："a flexible latform for reproducible modeling of species niches and distributions")，可以視為一個GUI app。具有開源 (open)、可擴充 (expandible)、可重複性 (reproducible) 三大特色，透過彈性且具互動性的操作介面，一步步引導使用者建立出自己的模型。Wallace曾入圍2015度 Ebbe Nielsen Challenge of the Global Biodiversity Information Facility (GBIF)，並被教授物種分布模型的相關概念。

[rasterViz](https://oscarperpinan.github.io/rastervis/#themes)是一個基於raster、lattice，及latticeExtra的R package，其主要功能為快速做出可投稿等級的網格資料圖，是我個人經驗中十分喜歡的一個raster data視覺化套件。

本指南會以操作步驟為主，相關模型原理在Wallace的每個階段中會友較為詳細的說明。我將分析與出圖所需要使用的指令稿整合於此專案中，使用者依照下列說明依序操作後，可以獲得：

1. 預測網格圖、
2. 相關模型參數圖、
3. 以PNG及TIFF呈現的結果圖。

## 使用教學

### Wallace (物種分布模型) 操作
#### 引用文獻
依照官方說明，在期刊論文中使用Wallace套件時，需要引用套件的正式發表論文，如下：

Kass JM, Vilela B, Aiello‐Lammens ME, Muscarella R, Merow C, Anderson RP. (2018). Wallace: A flexible platform for reproducible modeling of species niches and distributions built for community expansion. Methods in Ecology and Evolution. 9:1151–1156. https://doi.org/10.1111/2041-210X.12945

#### 環境建置
本script檔使用的R版本號為: 4.0.2，並建議透過Rstudio來執行。使用者請先至R與Rstudio官網下載、安裝此二軟體。此外，為了使安裝設定中的devtools運作，也請安裝Rtools40。

我已經將所需要的指令稿整合於專案資料夾中，請將整個資料夾打包下載，開啟後檔案結構如下。

![](https://i.imgur.com/wvLbRHt.png)

▲ 專案以Rstudio提供的Rproject型式統整：

-\\\\\\ Wallace
 |-\\\ .Rproj.user (Rproject使用者設定資料)
 |-\\\ Inputs      (用以輸入的資料)
 |-\\\ Outputs     (輸出的所有結果)
 |- .Rhistory      (Rproject歷程紀錄檔)
 |- main.R         (主要分析用指令稿)
 |- setup.R        (環境建置用指令稿)
 |_ Wallace.Rproj  (Rproject起始檔)


![](https://i.imgur.com/CrfYhyO.png)
▲ 以左鍵雙擊兩次「Wallace.Rproj」開啟此專案。

![](https://i.imgur.com/haWI13M.png)
▲ 此為Rstudio的介面，可以看到系統已同時開啟「main.R」與「setup.R」。

![](https://i.imgur.com/wJkh3tf.png)
▲ 若無，請手動開啟檔案。

接下來，將逐步執行code。請先逐步執行下方的code以安裝需要的packages。
```R=1
##使用R version: 4.0.2

##初次使用時安裝.
###----------1. Check the environment.-----------------------###
source("setup.R")
## 自動檢查R package的環境，如果不符合開發時package-
## 的版本，則自動重新安裝對應版本.

## 如果上面的安裝無法正確進行，請執行下方code。
# install.packages('wallace')

###----------------------------------------------------------###
```

完成安裝後，呼叫所有所需packages。
```R=37
##-----------3. Load required packages.--------------##

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
```

執行Wallace GUI。
```R=54
##-----4. Run Wallace to model the distribution of certain species.------##
# run the app
run_wallace()

##-----------------------------------------------------------------------##
```

![](https://i.imgur.com/DgGjAnq.jpg)
▲ Wallace將於電腦的預設瀏覽器中開啟，以我的電腦為例，開啟於Chrome中的新分頁，網址(阜號為： http://127.0.0.1:3764)

![](https://i.imgur.com/8wG4jJl.jpg)
▲ 同時，Rstudio的console中顯示開啟的阜號。注意右上方的紅色「Stop」亮起，表示Code正在執行中。如果需結束Wallace，可以在瀏覽器中直接關閉分頁，或在Rstudio console中點選「Stop」，但所有未載回存檔的內容將回遺失。

#### 以Wallace進行SDM

我們直接借用Wallace官方Vignette上的版面介紹。點選上方Toobar中的「1. Occ Data」後可以看到下面介面。
![](https://i.imgur.com/JYPPmSy.jpg)
▲ 點選上方Toobar中的「1) Occ Data」切換至新介面。

在介面中： [1]為工具列 (Toolbar)，用以切換不同的功能模組；[2]為控制面板；[3]為結果面板。[2a]為此模組所依賴的packages的名稱 (可以視為相關的引用資訊)，[2b]為用以控制此模組的選單。[3a]為此模組所實際運行的R code，[3b]為呈現結果的互動式視窗，可以用滑鼠拉動看看！

值得注意的是，在[3b]可以切換的數個頁面中，「Component Guidance」為此部分模組的詳細作用與延伸參考文獻，「Module Guidance」為構成此模組的R packages的相關引用資料與實行細節。透過研讀這兩個頁面的內容，我們可以更深入了解物種分布模型的理論基礎與運作原理。

![](https://i.imgur.com/beM8Z8H.png)
▲ Component Guidance。

![](https://i.imgur.com/muqnVtz.png)
▲ Module Guidance。

##### Obtain Occurrence Data

作為範例，本指南以昆蘭樹 (*Trochodendron aralioides* Siebold & Zucc.) 做為模擬對象。使用這個物種作為範例，一是此物種被認為是一冰河孓遺植物，且臺灣為其主要分布地；二是曾有論文以物種分布模型討論此物種在臺灣的可能分布情況，方便我們進行比對。

依序照數字所示設定：1)要使用資料庫，還是自己上傳點位。2)要選用哪個資料庫，以及要搜尋的物種學名，要載入的點位上限。結束後點選「Query Database」。
![](https://i.imgur.com/PzMjxNQ.png)
▲ 點選後可以看到進度條顯示資料載入進度。

完成後，4. 會顯示實際上載入了多少筆點位。Wallace預設會自動排除沒有座標資料及重複的點位資料，此範例中顯示最終載入477筆點位資料，並可以在下方的互動式面板中看到點位的分布。

![](https://i.imgur.com/euH9soi.png)
▲ 完成後的點位資料可以在此下載回電腦中，建議將所有載回的原始資料都儲存於專案的「Inputs」資料夾中。

![](https://i.imgur.com/lrUybRr.png)
▲ 如果切換到「Occs Tbl」頁面，可以看到逐筆資料的詳細資料與資料來源。

![](https://i.imgur.com/s6bAmSc.png)
▲ 以Excel開啟載回的".csv檔"，可以發現其格式同GBIF上資料下載的格式。

![](https://i.imgur.com/pYPFYnh.png)
▲ 如果要自己上傳點位資料，則資料格式需如上圖，僅有name、longitude、latitude三欄 (經緯度資料格式須為WGS84)。從資料庫下載回來的點位資料，可以整理成相同的格式後，與自己的資料合併然後上傳使用，以囊括所有可能點位。

##### Process Occurrence Data

在「2 Process Occs」模組中，我們可以進行資料清理。舉例而言，從GBIF下載回來的點位資料可能來自各個來源，可能是博物館中的標本資訊，也可能來自iNaturalist的觀察紀錄。這些點位資料不可避免有些偏誤，透過基本的選取或是地理上演算法的運算，我們可以校正這些偏誤，以免有偏誤的資料影響物種分布模型的配適結果。

因為我們是要預測昆蘭樹在臺灣的分布情況，以臺灣的點位資料來進行適最準確的，我們首先透過地圖選取只在台灣出現的點位資料。

![](https://i.imgur.com/dOfQTWb.png)
▲ 選取「Select Occurences On Map」。

![](https://i.imgur.com/RUNRguA.png)
▲ 選取這個按鈕，在地圖上畫出一個多邊形以包含需要的點位資料。

![](https://i.imgur.com/WnOE1zQ.png)
▲ 畫完後按下「Select Occurences」。

![](https://i.imgur.com/PZyAS0h.jpg)
▲ 可以看到只有被多邊形框起的點位被選取。

接下來，也可以透過選擇特定點位的ID，將其刪除。

![](https://i.imgur.com/VeMTgjr.png)
▲ 1)切換選取模式。2)直接點選目標點位，觀察其ID，在本例為801。3)輸入目標ID後，點選「Remove Occurence」，刪除該點位。

![](https://i.imgur.com/eTSxWQ7.jpg)
▲ 依序將離島以外的點位皆刪除。

點位資料可能存在取樣上的偏誤，例如：公民科學家活動頻繁的都市，周遭的物種分布紀錄可能比較密集且頻繁；又或者稀有物種的熱門觀察地點，每次遊客經過都會在同一處拍照並記錄到同一個個體。這些取樣偏誤會使模型配飾產生偏誤，在Wallace中有預設的「Spatial Thin」演算法，幫助我們台除過於密集的點位資料。

![](https://i.imgur.com/mkfwrlt.png)
▲ 1)選取「Spatial Thin」。2)輸入鄰近點位的最小距離，舉例而言10km，輸入完畢後按下「Thin Occurences」。

![](https://i.imgur.com/S5JOQri.png)
▲ 帶進度條跑完後，觀察右方地圖面板可以知道Wallace究竟做了甚麼？紅色的點位為留下的分布紀錄，藍色的為去除的，在地圖上相鄰10km以內的點位資料將被系統刪除而不用於配飾模型。此時透過左下方的「Download」按鈕可以下載回清理好的.csv檔。(註：此時地圖上台南及高雄的點位，我個人判斷應該不是昆蘭樹的天然分布區域，所以會透過上述從IDs刪除點位的方法排除。上述方法**可以**交錯使用，故不需要按照順序再次進行「Spatial Thin」。)

##### Obtain Environmental Data

接下來我們需要載入環境因子資料圖層。環境因子的資料將依據我們輸入的點位紀錄被抽取出來，進而被用以配飾模型。載入的環境因子資料圖層為網格資料的型式，也就是由一大片各自具有單一數字值的小格子所組成。網格資料可以想像成是一片蓋在地圖上的布。

![](https://i.imgur.com/ODMw564.png)
▲ 1)切換到「3. Env Data」。2)選擇「WorldClim Bioclims」，此為一個經常被用以物種分布模型上的全球尺度氣候資料圖層。此資料圖層是根據世界各地的氣象站資訊，經由空間內插法所獲得的全球氣候資料。WorldClim具有不同的解析度，我們選擇Wallace所能容許的最高解析度「30 arcsec」，並按下「Load Env Data」。(註：此處也可以上載使用者自己的圖層資料，只要在2.處選擇第二項「User-specified」即可。)

![](https://i.imgur.com/yrGzdpj.png)
▲ 載入完成後可以在1.發現載入圖層的詳細資料。此時可以在2.處選擇要用以配飾的WorldClim，WorldClim中共有19個指標(bio 1 – bio 19)，基本上對映的是一個區域的氣溫與雨量資訊，可以到[Worldclim官方網站](https://www.worldclim.org/)查看細節。如果不勾選，則預設全部代入。註：Wallace系統會自動刪除沒有網格資料可以對應的點位資料，可以於工作視窗中查看。

##### Process Environmental Data

接下來我們需要裁剪載入的環境圖層，使其符合我們的點位資料，用以進行模型配適。這個步驟最主要是要決定我們的「背景點位 (background points)」撒布的區域。何謂背景點位？機器學習的模型，例如：Maxent，有時需要在模型中使用背景點位，這些模型比較背景點位的環境資料與物種真實分布點位的環境資料，藉以判斷物種分布於一地點的潛在可能。背景點位需要被撒布於目標物種可以分布的所有範圍，如果是陸生物種則背景點位的範圍不可包含水域，因此才需要裁減環境圖層。同理，地景內若有路生物種無法跨越的地理屏障，例如：大峽谷對蚯蚓來說可能難以跨越，則也需要考慮背景點位的撒布範圍，否則模型將有偏誤。

![](https://i.imgur.com/gRkh4yM.png)
▲ 如圖所示：1)點選「Select Study Region」。2)點選「Minimum convex polygon」，設定「1 (degree)」，並按下「Select」。

![](https://i.imgur.com/XyzYxhK.png)
▲ 各點位將以設定的參數進行連結，產生預裁剪區域。由於我們使用的物種是植物，所以這邊會需要反覆設定參數直到其只涵蓋陸域，但此指南假設此問題不存在。

![](https://i.imgur.com/buwUlHK.png)
▲ 第二步是進行背景點位的撒布。1)設定欲撒布的背景點位數量，並按下「Sample」。2)這邊可以下載被選定區域屏蔽的環境圖層。

##### Partition occurrences


為了評估我們的模型的解釋力，理論上我們需要數組獨立的點位資料以進行評估。但，現實情況往往是沒有這些資料，所以我們可以將現有點位資料切割成數份，分別建模，並使用沒有被用以建模的其他資料進行模型驗證。Wallace內建有「random k-fold」跟「spatial blocking」兩種資料分隔與評估的方法，使用者可以依照自己的需求挑選。完成評估後，Wallace會自動整合所有模型的資訊，並配適出一個最終模型。在此指南中，我們選用「spatial blocking」作為示範，各方法的優劣請詳見「Component Guidance」。

![](https://i.imgur.com/29N8ILZ.png)
▲ 1)選擇「Spatial Partition」。2)選擇「Block (k = 4)」，並按下「Partition」。

![](https://i.imgur.com/EMgwVbk.png)
▲ 右方工作區會呈現資料分割好的狀態，不同顏色的點位代表不同的分隔群組。

##### Model

接下來終於要進入建模的步驟。在此指南中，我們使用「Maxent」進行建模，但實際上Wallace是可以擴充的，可以依照[官方教學](https://cmerow.github.io/RDataScience/3_4_wallace.html)自行擴增可以使用的模型數量。

如果要使用dismo::maxent，需要先確認package: dismo的java資料夾中含有「maxent.jar」檔案，此為maxent的執行檔，可以[由此下載](https://biodiversityinformatics.amnh.org/open_source/maxent/)。
請找到「C:\Users\使用者名稱\Documents\R\win-library\4.0\dismo\java」這個路徑位置，並將下載下來的壓縮檔解壓縮至此。

![](https://i.imgur.com/ZBDcymd.png)
▲ 資料夾中須包含這四個檔案。

![](https://i.imgur.com/cjHwPA3.png)
▲ 1)選擇「Maxent」。2)選擇使用「maxent.jar」，並依序設定建模參數，本文依照Wallace的官方教學簡易設定，結束後按下「Run」。註：若於2)中選擇「maxent」，會使用另外一個package: maxent來執行maxent演算法，讀者可以自行嘗試。

![](https://i.imgur.com/xuczBar.png)
▲ 完成後可於「Results」頁面查看結果。

![](https://i.imgur.com/o4nkbqB.png)
▲ 本指南採用「avg.test.AUC」值最高的「L_3」模型進行後續投影。如何挑選最佳的模型有若干文章討論，請見「Component Guidance」。

##### Visualize

Wallace提供了三種不同的視覺化方式，用以評估模型的各種面向。

**Maxent Evaluation Plots**可以讓使用者評估個別模型之間的統計量差異。

![](https://i.imgur.com/F0NkIQc.png)
▲ 1)選擇「Maxent Evaluation Plots」。2)選擇欲呈現的模型ID。3)圖片呈現於此。

**Plot Respense Curves**可以讓我們檢視各變數值與物種潛在分布可能(predicted value)之間的關係。

![](https://i.imgur.com/ckeQuaq.png)
▲ 1)選擇「Plot Respense Curves」。2)選擇欲呈現的模型ID及欲呈現的變數。3)圖片呈現於此。此圖呈現在「L_3」模型下「bio09 (Mean Temperature of Driest Quarter)」的反應曲線，如圖可以看到隨著氣溫上升，物種潛在分布可能下降，呈現一個「拉長的反S形曲線」。註：WorldClim的溫度資料是以整數儲存，所以實際溫度要除以10，例如：200 unit = 200 / 10 = 20 deg C。

**Map Prediction**可以將潛在分布地圖疊加於底圖上，讓我們檢視配飾好的物種分布模型所預測的潛在分布範圍。

![](https://i.imgur.com/S7VsjTr.png)
▲ 1)選擇「Map Prediction」。2)選擇欲呈現的模型ID，此模式下變數選擇無作用。3)選擇欲出圖的模式，按下「Plot」。4)出圖於此。5)可以將預測地圖載回供後續使用。如要使用此指南的R code出圖建議下載GeoTIFF格式(.tif)。註：每一個模式都可以將結果圖載回。

##### Project

接下來，建立好的模型可以用以預測不同地區或不同時間點的物種分布可能性，只要將更動的變數帶入建立好的模型，我們可以得到新的輸出，這個過程稱為「投影 (Project)」。

在此指南中，我們使用L_3模型進行投影，並分別投影到不同地理區域(整個東亞)，與不同時間點。為了方便比較，我們使用跟前人文章中一樣的氣候變遷情境(year 2050 (average for 2041–2060), bio01 - bio19, CCSM4 under the RCP4.5 scenario.)。但結果發現前面的「30 arcsec」在Wallace中尚不支援投影到未來時間，故我們重新執行「步驟3 – 步驟8」，這次選擇「2.5 arcmin」解析度。

![](https://i.imgur.com/OEL1bWi.png)
▲ 重新執行上述過程。

![](https://i.imgur.com/BcnrQKr.png)
▲ 這次最好的模型是「L_2」。

![](https://i.imgur.com/JGFHkwp.png)
▲ 投影到不同地理區域的範例。

![](https://i.imgur.com/uyZwFTA.png)
▲ 先使用地圖工具列，在圖上畫出欲投影的範圍，再點選左邊的「Project」。

![](https://i.imgur.com/WFAmtuJ.png)
▲ 如圖，在左邊設定未來情境後，按下「Project」。並可以載回投影好的圖檔。

![](https://i.imgur.com/w1LO3Fu.png)
▲ 在「Calculate Environmental Similarity」模組中，我們可以計算載入圖層的環境異質度。同樣作為一項指標數值，可以視需要載回使用。

##### Extracting the code

Wallace是可重複的，也就是說，剛才執行的各步驟的R code，實際上會被保留於電腦中，並且可以在此步驟載回。下一次進行相同分析，只需要執行R code即可，不需要重新點選GUI。如果你會修改code，也可以直接修正R code以達到客製化分析的效果。

![](https://i.imgur.com/8zBQHvw.png)
▲ 點選載回的格式，如果是要重做分析，建議載回「Rmarkdown (.Rmd)」，另外有PDF與WORD檔可以下載。

![](https://i.imgur.com/OzxG3SM.png)
▲ 以Rstudio開啟載回的Rmarkdown檔案。

![](https://i.imgur.com/DTFss9I.png)
▲ Rmarkdown檔案可以被匯出成html檔。

![](https://i.imgur.com/hn2PlFd.png)
▲ 載回的code文檔。

### rasterVis (出圖) 操作

前面載回的GeoTIFF檔可以透過R輸出成較美觀的發表等級圖版，相關code整合於專案資料夾中的「main.R」，以下為使用教學，請依序於Rstudio中執行各區塊。

執行「步驟2」，設定檔案參數。
```R=14
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
```

執行「步驟5」，設定出圖模式。
```R=60
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
```

執行「步驟6」，設定存檔。
```R=89
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
```

![](https://i.imgur.com/xN3TNRL.png)
▲ 輸出的圖檔存於專案資料夾中的子資料夾「Outputs」。

![](https://i.imgur.com/QHN4i8m.png)
▲ 完成輸出的圖片長這樣！

**註**：如果想要在網格圖片上標上行政區界，請執行「步驟 Extra-plus 繪上行政區界線」，然後再次執行「步驟6」。

```R=116
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
```

![](https://i.imgur.com/njyW1ae.png)
▲ 已加上行政區界。

**註**：如果想將兩圖放在一起，並排顯示並使用相同的色階圖例，請確認兩圖解析度相同後，執行「步驟 Extra-plus 把兩圖放在一起比較」，然後再次執行「步驟6」。(若須加上行政區界，則須先執行「步驟 Extra-plus 繪上行政區界線」，再執行「步驟 Extra-plus 把兩圖放在一起比較」。)
```R=145
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
```

![](https://i.imgur.com/BgnedQj.png)
▲ 結果，把兩圖並排顯示。這邊因為我重複載入了兩次一樣的圖檔，所以兩圖看起來一樣。

![](https://i.imgur.com/C2v3sz8.png)
▲ 透過最後第183行的code，也可以單獨輸出符合B圖座標的「A圖內容」。

**DONE！**

## 結語

物種分布模型在政策評估與了解環境因子對物種分布的影響...等議題上十分有用，感謝Wallace團隊與R語言讓整個過程變得較為容易。此指南為一個簡單的教學，作為一個自己學習上的紀錄，也希望我的經驗可以協助到遇到相同問題的其他人。

## 延伸閱讀
1. [Wallace project](https://wallaceecomod.github.io/)
2. [rasterVis官方介紹](https://oscarperpinan.github.io/rastervis/#themes)
3. [R spatial繪圖指南―Drawing beautiful maps programmatically with R, sf and ggplot2](https://www.rs-patial.org/r/2018/10/25/ggplot2-sf.html)
4. [rnaturalearth](https://cran.r-project.org/web/packages/rnaturalearth/vignettes/rnaturalearth.html)
5. [Plots with raster and rasterVis](https://pjbartlein.github.io/REarthSysSci/rasterVis01.html)
6. [Briscoe Runquist RD, Lake T, Tiffin P. et al. (2019) Species distribution models throughout the invasion history of Palmer amaranth predict regions at risk of future invasion and reveal challenges with modeling rapidly shifting geographic ranges. Scientific Reports 9: 2426.](https://www.nature.com/articles/s41598-018-38054-9#Sec9)
7. [Lin CT, Chiu CA (2019) The Relic Trochodendron aralioides Siebold & Zucc. (Trochodendraceae) in Taiwan: ensemble distribution modeling and climate change impacts. Forests 10: 7.](https://www.mdpi.com/1999-4907/10/1/7/htm#B43-forests-10-00007)

## 變更日誌
* 2020/08/14-16:11 完成Version1.0的使用說明及相關code。

## Appendix and FAQ

:::info
**Find this document incomplete?** Leave a comment!
:::

###### tags: `GIS` `Documentation` `SDMs` `R`
