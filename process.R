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
nrow(direcciones.1)
hist(nchar(as.character(direcciones.1$DIRECCION)))
#direccion.problem.nchar<-max(nchar(direcciones.1$DIRECCION.CLEAN))
direccion.problem.nchar<-21485
#[1] 21485

problem.row<-which(nchar(direcciones.1$DIRECCION.CLEAN)==direccion.problem.nchar)
if (length(problem.row)>0){
  direcciones.1.wide.address<-direcciones.1[problem.row,]
  direcciones.1<-direcciones.1[-problem.row,]
}

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

direcciones.1.not.parsed<-direcciones.1[which(nchar(direcciones.1$regexp)==0),]


#direcciones 2
direcciones.2$DIRECCION.CLEAN<-getCleanedDIRECCION(direcciones.2$DIRECCION)

direcciones.2$regexp<-setupRegexp(direcciones.2$DIRECCION.CLEAN,
                                  regexp.candidates=regexp.candidates)
aggregate(direcciones.2$regexp,by=list(regexp=direcciones.2$regexp),FUN=length)

#direcciones not regexped
direcciones.2[which(nchar(direcciones.2$regexp)==0),c("DIRECCION","DIRECCION.CLEAN")]

direcciones.2$calle<-trimws(apply(direcciones.2,MARGIN=1,FUN=function(x){sub(x["regexp"],"\\1",x["DIRECCION.CLEAN"])}))
direcciones.2$numero<-trimws(apply(direcciones.2,MARGIN=1,FUN=function(x){sub(x["regexp"],"\\2",x["DIRECCION.CLEAN"])}))

direcciones.2.not.parsed<-direcciones.2[which(nchar(direcciones.2$regexp)==0),]


#output
write.csv(direcciones.1,"DATA/direcciones-1-processed.csv",row.names=FALSE)
write.csv(direcciones.1.wide.address,"DATA/direcciones-1-row 1254problem.csv",row.names=FALSE)
write.csv(direcciones.2,"DATA/direcciones-2-processed.csv",row.names=FALSE)

write.csv(direcciones.1.not.parsed,"DATA/direcciones-1-not-parsed.csv",row.names=FALSE)
write.csv(direcciones.2.not.parsed,"DATA/direcciones-2-not-parsed.csv",row.names=FALSE)
