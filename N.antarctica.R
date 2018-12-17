install.packages('dismo')
install.packages('raster')
install.packages('spocc')
install.packages('ENMeval')
install.packages('mapr')

library(raster)
library(spocc)
library(dismo)
library(ENMeval)
library(mapr)

beechtree <- occ(query='Nothofagus antarctica', from = 'gbif', limit=2500)

df = as.data.frame(occ2df(beechtree$gbif))

map_leaflet(beechtree)

clim = getData('worldclim', var='bio', res=5)

ext = extent(-80, -60, -60, -30)

wc = crop(clim, ext)

occdat <- occ2df(beechtree)

loc = occdat[,c('longitude', 'latitude')]

extr = extract(wc, loc)

loc = loc[!is.na(extr[,1]),]

eval = ENMevaluate(occ=as.data.frame(loc), env = wc, method = 'block', parallel = FALSE, fc=c("L", "LQ"), RMvalues=seq(0.5, 2, 0.5), rasterPreds=T)

eval@results

best = which(eval@results$AICc == min(eval@results$AICc))

plot(eval@predictions[[best]])

points(as.data.frame(loc), pch=20, cex=0.1)

est.loc=extract(eval@predictions[[best]], as.data.frame(loc))

est.bg=extract(eval@predictions[[best]], eval@bg.pts)

ev=evaluate(est.loc, est.bg)

thr=threshold(ev)

plot(eval@predictions[[best]] > thr$equal_sens_spec, col = c('lightgrey', 'forestgreen'))
