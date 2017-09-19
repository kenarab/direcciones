pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

removeAccents<-function(text){
  #TODO stuff '
  ret<-iconv(text, to='ASCII//TRANSLIT')
  ret<-gsub("'|\\~","",ret)
  ret
}

normalizeString<-function(text){
  removeAccents(trimws(tolower(text)))
}


getCleanedDIRECCION<-function(direcciones){
  direcciones<-normalizeString(direcciones)
  direcciones<-gsub("n^0","",direcciones,fixed = TRUE)
  direcciones<-gsub("^0","",direcciones,fixed = TRUE)
  direcciones<-gsub('"u',"u",direcciones,fixed = TRUE)
  direcciones<-gsub(",","",direcciones,fixed = TRUE)
  direcciones<-gsub(".","",direcciones,fixed = TRUE)
  direcciones<-gsub("  "," ",direcciones)
  trimws(direcciones)
}

setupRegexp<-function(direcciones,regexp.candidates){
  ret.regexp<-rep("",length(direcciones))
  for (regexp in regexp.candidates){
    #regexp<-regexp.candidates[1]
    rows.direcciones.left<-which(nchar(ret.regexp)==0)
    ret.regexp[grep(regexp,direcciones[rows.direcciones.left])]<-regexp
  }
  ret.regexp
}