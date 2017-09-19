source("direcciones-lib.R")
direcciones.1<-read.csv("DATA/direcciones-1.tsv",sep="\t")
direcciones.1$origin<-"D1"
head(direcciones.1)
direcciones.2<-read.csv("DATA/direcciones-2.tsv",sep="\t")
head(direcciones.2)
direcciones.2$origin<-"D2"

head(direcciones.1)
direcciones.1$DIRECCION.CLEAN<-getCleanedDIRECCION(direcciones.1$DIRECCION)
direcciones.1[grep(" no ",direcciones.1$DIRECCION.CLEAN),]$DIRECCION.CLEAN

regexp.candidates<-c("^([a-z ]*)([0-9]+)", #general
                     "^([a-z ]*)' no '{0,1}([0-9]+)" #av
                     )
direcciones.1$regexp<-setupRegexp(direcciones.1$DIRECCION.CLEAN,
                                  regexp.candidates=regexp.candidates)
aggregate(direcciones.1$regexp,by=list(regexp=direcciones.1$regexp),FUN=length)

#direcciones not regexped
direcciones.1[which(nchar(direcciones.1$regexp)==0),c("DIRECCION","DIRECCION.CLEAN")]

direcciones.1$calle<-trimws(apply(direcciones.1,MARGIN=1,FUN=function(x){sub(x["regexp"],"\\1",x["DIRECCION.CLEAN"])}))
direcciones.1$numero<-trimws(apply(direcciones.1,MARGIN=1,FUN=function(x){sub(x["regexp"],"\\2",x["DIRECCION.CLEAN"])}))

#direcciones 2
direcciones.2$DIRECCION.CLEAN<-getCleanedDIRECCION(direcciones.2$DIRECCION)

direcciones.2$regexp<-setupRegexp(direcciones.2$DIRECCION.CLEAN,
                                  regexp.candidates=regexp.candidates)
aggregate(direcciones.2$regexp,by=list(regexp=direcciones.2$regexp),FUN=length)

#direcciones not regexped
direcciones.2[which(nchar(direcciones.2$regexp)==0),c("DIRECCION","DIRECCION.CLEAN")]

direcciones.2$calle<-trimws(apply(direcciones.2,MARGIN=1,FUN=function(x){sub(x["regexp"],"\\1",x["DIRECCION.CLEAN"])}))
direcciones.2$numero<-trimws(apply(direcciones.2,MARGIN=1,FUN=function(x){sub(x["regexp"],"\\2",x["DIRECCION.CLEAN"])}))
