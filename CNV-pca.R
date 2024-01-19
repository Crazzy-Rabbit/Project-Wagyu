## CNV PCA 450 420
library(ggplot2)
library(scales)
library(ggthemes)
a = read.table("PCA.gcta.out.eigenvec",header=F)
m = as.matrix(read.table("PCA.gcta.out.eigenval",header=F))

explainm=m/sum(m)
pc1 = paste("PC1","(",percent(explainm[1,], accuracy=0.01),")", sep="")
pc2 = paste("PC2","(",percent(explainm[2,], accuracy=0.01),")", sep="")
Breed=a[,1]; PC1=a[,3]; PC2=a[,4]
m_shape=c("Wagyu"=21,"Angus"=22,"Holstein"=24)
  
p = ggplot(data=a,aes(x=PC1, y=PC2, group=Breed,
                      shape=Breed,color=Breed,fill=Breed))+
    geom_point(size=5,alpha=0.8,stroke=1,color="black")+
    scale_shape_manual(values=m_shape) 
p + labs(x = pc1, y = pc2)+ 
    geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
    geom_vline(xintercept = 0, linetype = "dashed", color = "black") +
    theme_base() +
    #theme(panel.border = element_rect(fill=NA,color="black", size=0.5, linetype ="solid")) +
    theme(legend.position =c(0.15,0.85),legend.title=element_blank())
