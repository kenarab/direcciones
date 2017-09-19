source("direcciones-lib.R")
direcciones.1<-read.csv("DATA/direcciones-1.tsv",sep="\t")
direcciones.1$origin<-"D1"
head(direcciones.1)
direcciones.2<-read.csv("DATA/direcciones-2.tsv",sep="\t")
head(direcciones.2)
direcciones.2$origin<-"D2"

direcciones.1$DIRECCION.CLEAN<-getCleanedDIRECCION(direcciones.1$DIRECCION)
direcciones.1[grep(" no ",direcciones.1$DIRECCION.CLEAN),]
direcciones.1$regexp<-setupRegexp(direcciones.1$DIRECCION)
