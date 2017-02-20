library(shiny)
# load("sexdiffs.rdata")
# library(rgeos); library(rgdal); 
library(ggplot2); 
# library(maptools)
# 
# # Data from http://thematicmapping.org/downloads/world_borders.php.
# # Direct link: http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip
# # Unpack and put the files in a dir 'data'
# 
# 
# # gpclibPermit()
# # http://www.naturalearthdata.com/downloads/110m-cultural-vectors/
# world.map <- readOGR(dsn="ne_110m_admin_0_countries", layer="ne_110m_admin_0_countries")
# 
# worldRobinson <- spTransform(world.map, CRS("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"))
# worldRobinson$NAME = worldRobinson$name
# world.ggmap <- fortify(worldRobinson, region = "NAME")
# world.map.df <- data.frame(id = unique(worldRobinson$NAME), centroids = as.data.frame(coordinates(worldRobinson)))
# 
# # 	setdiff(world.map.df$id,sexdiffs$Country)
# # 	setdiff(sexdiffs$Country, world.map.df$id)
# 
# 
# countries = merge(world.map.df,sexdiffs,by.x='id',by.y='Country',all.x=T)

load(file = "maps.rdata")
reverse_neg = function(x, maxdiff) { -1 * x + maxdiff }

shinyServer(function(input, output) {

	
  output$distPlot <- renderPlot({
  	moderator = "GDP"
  	sexdiff = input$age_range
  	maxdiff = max(countries[, sexdiff],na.rm = T)
  	countries$pos = 0.1 + reverse_neg(countries[,sexdiff], maxdiff)
  	
  	if(input$zoom == 1) {
  		map_ylim = c(-6625154, 8343004)
  		map_xlim = c(-12810131,15810131)
  	} else if(input$zoom == 2) {
  		map_ylim = c(3543004, 8343004)
  		map_xlim = c(-0.1e7,+0.35e7)
  	} else if(input$zoom == 3) {
  		map_ylim = c(-6625154, +3e6)
  		map_xlim = c(-12810131,-0.2e7)
  	}
#   	
#   	modplot = ggplot(countries, aes(map_id = id)) +
#   		geom_map(aes_string(fill = moderator), map = world.ggmap, colour="#AEAEAE",size=0) +
#   		expand_limits(x = world.ggmap$long, y = world.ggmap$lat) +
#   		coord_equal(ylim= map_ylim,xlim= map_xlim)+
#   		geom_point(aes_string(x = "centroids.V1",y = "centroids.V2", size = "pos"),data=countries,shape="♀",colour=NA) +
#   		geom_text(label='', aes_string(x = "centroids.V1",y = "centroids.V2", size = "pos"),
#   							vjust = 0, data= countries, alpha = 0.8, colour="#000000", family = "FontAwesome", face = "Regular",show_guide = F) +
#   		scale_fill_continuous(moderator,low = "#be4a18", high = "#3997c6", space = "Lab", na.value = "#CCCCCC") +
#   		scale_colour_continuous(low = "blue", high = "pink", space = "Lab",guide=F)+
#   		scale_size_area("self esteem sex difference", breaks = 0.1 + reverse_neg(c(0.01, 0.10, 0.20, 0.30), maxdiff), labels = -1*c(0, 0.10, 0.20, 0.30)) + 
#   		guides(size = guide_legend(override.aes = list(colour = "black", shape = 16, family = "FontAwesome"))) +
#   		theme_minimal() + theme(panel.grid.major.y = element_blank(), panel.grid.major.x=element_blank(),panel.grid.minor=element_blank(), axis.ticks = element_blank(), axis.text = element_blank(),axis.title=element_blank())	
#   	# 	ggsave(filename = "world_map_GDP_sexdiff.png", width = 20, height = 10)
#   	
#   	
  	simplemap = ggplot(countries, aes(map_id = id)) +
  		geom_map(aes_string(fill = sexdiff), map = world.ggmap, colour="#AEAEAE",size=0) +
  		expand_limits(x = world.ggmap$long, y = world.ggmap$lat) +
  		coord_equal(ylim= map_ylim,xlim= map_xlim)+
  		scale_fill_continuous("self esteem\nsex difference\n(Cohen's d)",low = "pink", high = "#89CFF0", space = "Lab", na.value = "#CCCCCC", guide = guide_colourbar(barheight=10), limits = c(0, 0.4)) +
  		theme_minimal() + theme(panel.grid.major.y = element_blank(), panel.grid.major.x=element_blank(),panel.grid.minor=element_blank(), axis.ticks = element_blank(), axis.text = element_blank(),axis.title=element_blank())

  	if(input$plot == 1) {
				simplemap + geom_text(aes(x = centroids.V1,y = centroids.V2, label = ifelse(is.na(Across.Age),"",id)),size = 3, vjust = 0, data= countries, alpha = 0.8, show_guide = F)
  	} else if(input$plot == 2) {
  		simplemap
   	} else {
  		modplot
  	}
  },width = "auto", height = 650)

})
