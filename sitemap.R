### Sitemap
#Libraries
library(tmap)
library(tmaptools)
library(sf)
library(leaflet)
library(raster)
library(rnaturalearth)
library(rnaturalearthdata)
library(rnaturalearthhires)
library(ggplot2)

theme_set(theme_bw())


#Data sourced from Geoscience Australia (GEODATA TOPO 250K from data.gov.au)
water <- st_read("~/Documents/Coorong Denitrifying Bacteria/QIIME2R/prelim/mapdata/TOPO_Waterbodies_GDA2020.shp")
lakes <- st_read("~/Documents/Coorong Denitrifying Bacteria/QIIME2R/prelim/mapdata/lakes.shp")
watercourse <- st_read("~/Documents/Coorong Denitrifying Bacteria/QIIME2R/prelim/mapdata/watercourseareas.shp")
coast <- world <- ne_coastline(scale = "large", returnclass = "sf")
main <- st_read("~/Documents/Coorong Denitrifying Bacteria/QIIME2R/prelim/mapdata/frameworkboundaries.shp")

#Check shapefiles are SF format with class(<shapefilex.shp>) prior to plotting or its a nightmare

#Layer .shp files
coor <- ggplot() + geom_sf(data = main) + geom_sf(data = lakes, fill = "aliceblue") + 
  geom_sf(data = watercourse, fill = "aliceblue")

#Add scale and north arrow from ggspatial
library(ggspatial)

cooro <- coor + annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.18, "in"), pad_y = unit(1, "in"), style = north_arrow_fancy_orienteering)

#Define bbox (map bounds) coordinates last as whichever is defined last is used
cooron <- cooro + coord_sf(xlim = c(138.9, 139.8), ylim = c(-36.25, -35.3), expand = FALSE)

#Add sites with geom_point
sites <- read.csv("map.csv")

sites$Site <- factor(sites$Site, c("Lake Albert", "Long Point", "Salt Creek"))

coorong <- cooron +
  geom_point(data=sites, aes(x=Longitude, y=Latitude, shape=Site, size = 1.2)) +  
  theme(panel.grid.major = element_line(color = "white"))

#Annotate plot
coorong_map <- coorong + annotate(geom="text", x= 139.1 , y= -35.45, label="Lake Alexandrina", fontface="italic", color ="grey22") +
  annotate(geom="text", x=139.29 , y=-35.605, label="L. Albert", fontface="italic", color ="grey22") +
  annotate(geom="text", x=139.1 , y=-35.8, label="North Lagoon", fontface="italic", color ="grey22") +
  annotate(geom="text", x=139.65 , y=-35.93, label="South Lagoon", fontface="italic", color ="grey22") +
  guides(colour = guide_legend(override.aes = list(size=10)))
 # theme(axis.text.x = element_text(angle = 45))

print(coorong_map)
