#' @title Interlocking Directorates Network
#'
#' @description This function creates an interlocking directorates network from a list of company number
#' @param coynoLIST list of company numbers
#' @param mkey Authorisation key
#' @param LABEL Node Label - TRUE/FALSE
#' @param NodeSize Node Size - default is 6, place number or CENTRALITY (degree centrality)
#' @export
#' @return Two-Mode Interlocking Directorates Network - igraph object
InterlockNetworkPLOT<-function(coynoLIST,mkey,LABEL,NodeSize){
  DATA<-list()
  for (i in 1:length(coynoLIST)){
    DATA[[i]]<-ExtractDirectorsData(coynoLIST[i],mkey)
  }
  Rdata<-plyr::ldply(DATA, data.frame)

  HH<-cbind(as.character(Rdata$id),as.character(Rdata$directors))
  colnames(HH)<-c("CompanyID","Director")
  HH2<-unique(HH)
  HH2[is.na(HH2)] <- "na"
  HH2<-as.data.frame(HH2)
  HH3<-dplyr::filter(HH2,HH2$Director!="na")

  INTERLOCK<- igraph::graph.data.frame(HH3)

  igraph::V(INTERLOCK)$type <- igraph::V(INTERLOCK)$name %in% HH3$Director
  D1<-igraph::V(INTERLOCK)$type
  DC<-as.character(D1)
  DC<-gsub("TRUE", "Director", DC)
  DC<-gsub("FALSE", "Company", DC)
  igraph::V(INTERLOCK)$DC<-as.vector(DC)

  INTERLOCKnet<-intergraph::asNetwork(INTERLOCK)

  if (NodeSize=="CENTRALITY"){
    NAMElist<-network::get.vertex.attribute(INTERLOCKnet,"vertex.names")
    NAMElist<-as.data.frame(NAMElist,stringAsFactors=FALSE)
    colnames(NAMElist)<-"NAME"
    INTERcent<-InterlockCentrality(INTERLOCK)
    CC<-INTERcent
    NS<-CC[ order(match(CC$NAMES, NAMElist$NAME)), ]
    NodeSize<-NS$Degree.Centrality
  }else{NodeSize<-NodeSize}

  if (LABEL==TRUE){
    GGally::ggnet2(INTERLOCKnet,
                   node.size=NodeSize,node.color = DC,color.palette = "Set1",
                   color.legend = "Type",label = TRUE,label.size = 2.5,
                   edge.color =  "grey50",arrow.size=0 )+
      ggplot2::guides(size = FALSE)

  } else{
    GGally::ggnet2(INTERLOCKnet,
                   node.size=NodeSize,node.color = "DC",color.palette = "Set1",
                   color.legend = "Type",label = FALSE,
                   edge.color =  "grey50",arrow.size=0 )+
      ggplot2::guides(size = FALSE)
  }

}

