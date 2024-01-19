library(ggplot2)
library(openxlsx)
kegginput <- read.xlsx("go.xlsx")

x=kegginput$logp
y=factor(kegginput$Term,levels = kegginput$Term)
p = ggplot(kegginput,aes(x,y))
p1 = p + geom_point(aes(size=Count,color=-0.5*log(pvalue)))+
    # scale_color_gradient(low = "BLUE", high = "OrangeRed") +
      scale_color_gradient(low = "SpringGreen", high = "OrangeRed") +
     theme_bw() +
     theme(panel.border = element_rect(fill=NA,color="black", size=0.5, linetype ="solid"))

p2 = p1 + labs(color=expression(-log[10](pvalue)),
               size="Count",x="",y="",title="")
p2



library(ggplot2)
library(openxlsx)
library(RColorBrewer)
library(ggthemes)
library(patchwork)

kegginput <- read.xlsx("kegg.xlsx")
x=kegginput$logp
y=factor(kegginput$Term, levels=kegginput$Term)

p1 = ggplot(kegginput,aes(x=x,y=y))+ 
     geom_point(aes(size=Count,color=-0.5*log(pvalue)))+
     geom_text(aes(x=0, y=y,label=y, color=-0.5*log(pvalue)), 
               hjust=(0))+
     scale_color_gradient(low = "BLUE", high = "OrangeRed")  + 
     theme_few()+
     labs(size="Count", color=expression(-log[10](pvalue)), title="KEGG pathway", x=expression(-log[10](pvalue)), y="")+
     theme(axis.text.x=element_text(face="bold"),
           axis.ticks = element_blank(),
           axis.text.y=element_blank())
p1

goinput <- read.xlsx("go.xlsx")
x1=goinput$logp
y1=factor(goinput$Term, levels=goinput$Term)

p2 = ggplot(goinput, aes(x=x1,y=y1))+ 
     geom_bar(stat="identity",width = 0.4,position = position_dodge(0.7),
              aes(fill=-0.5*log(pvalue)))+
     geom_point(aes(size=Count,color=-0.5*log(pvalue)), color="gray")+
     geom_text(aes(x=0, y=y1, label=y1), color="black",
               hjust=(0))+
     scale_color_gradient(low="SpringGreen", high="OrangeRed")+ 
     scale_fill_gradient(low="SpringGreen", high="OrangeRed")+ 
     theme_few()+ 
     labs(size="Count", fill=expression(-log[10](pvalue)), title="GO terms", x=expression(-log[10](pvalue)), y="")+
     theme(axis.text.x = element_text(face="bold"),
           axis.ticks = element_blank(),
           axis.text.y = element_blank())
p2
