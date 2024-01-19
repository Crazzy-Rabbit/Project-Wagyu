# 绘制散点样式的箱型图
library(ggplot2)
library(RColorBrewer)
a=read.table("gene_cnv.txt",header=T)
ggplot(a,aes(x=POP,y=UMAD1,fill=POP))+  
  geom_boxplot(outlier.shape = NA)+ 
  geom_jitter(width=0.2, alpha=0.5) +
  labs(x="UMAD1",y = "Normalized Copy Number")+ 
  theme_classic() + 
  theme(panel.border=element_rect(fill=NA,color="black", 
                                  linewidth=0.5, linetype ="solid"))+
  theme(legend.position="none")


library(ggplot2)
library(RColorBrewer)
a=read.table("gene_cnv.txt",header=T)
ggplot(a,aes(x=POP,y=ctnna3,fill=POP))+  
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(width=0.2, alpha=0.5)+
  labs(x="CTNNA3",y = "Normalized Copy Number")+ 
  theme_classic() + 
  theme(panel.border=element_rect(fill=NA,color="black", 
                                  linewidth=0.5, linetype ="solid"))+
  theme(legend.position="none")
