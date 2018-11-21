library(spocc)
library(mapr)
library(raster)

squirrels <- occ(query='Callosciurus prevostii', from='gbif', limit=2500)
df = as.data.frame(squirrels$gbif$data$Callosciurus_prevostii)

clim = getData('worldclim', var='bio', res=5)

library(ENMeval)

occdat <- occ2df(squirrels)
map_leaflet(squirrels)
ext = extent(95, 129, -8, 27)
predictors = crop(clim, ext)
plot(predictors[[1]])
loc = occdat[,c('longitude', 'latitude')]
extr = extract(predictors, loc)
loc = loc[!is.na(extr[,1]),]
eval = ENMevaluate(occ=as.data.frame(loc), env=predictors, method='block', parallel=FALSE, fc=c("L", "LQ"), RMvalues=seq(0.5, 2, 0.5), rasterPreds = T)
eval@results
best=2
plot(eval@predictions[[best]], col=topo.colors(9))
plot(eval@predictions[[best]])
points(as.data.frame(loc), pch=20, cex=0.1)
plot(eval@predictions[[best]] > 0.0001)
points(as.data.frame(loc), pch=20, cex=0.1)
est.loc=extract(eval@predictions[[best]], loc)
est.bg=extract(eval@predictions[[best]], eval@bg.pts)
ev = evaluate(est.loc, est.bg)
thr = threshold(ev)
plot(eval@predictions[[best]] > thr$equal_sens_spec, col=c('lightgrey', 'pink'))
points(as.data.frame(loc), pch=20, cex=0.1)