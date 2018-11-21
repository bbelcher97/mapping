library(spocc)
library(mapr)

squirrels <- occ(query='Sciuridae', from='gbif', limit=2500)
df = as.data.frame(squirrels$gbif$data$Sciuridae)
map_leaflet(squirrels)