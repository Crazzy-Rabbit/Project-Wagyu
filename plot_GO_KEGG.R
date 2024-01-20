library(ggplot2)
library(patchwork)
library(openxlsx)
goinput <- read.xlsx("go.xlsx")

x=goinput$logp
y=factor(goinput$Term,levels = goinput$Term)
p = ggplot(goinput,aes(x,y))
p1 = p + geom_point(aes(size=Count,color=-0.5*log(pvalue)))+
  # scale_color_gradient(low = "BLUE", high = "OrangeRed") +
  scale_color_gradient(low = "SpringGreen", high = "OrangeRed") +
  theme_bw() +
  theme(panel.border = element_rect(fill=NA,color="black", size=0.5, linetype ="solid"))

p2 = p1 + labs(color=expression(-log[10](pvalue)),
               size="Count",x="",y="",title="")
p2


kegginput <- read.xlsx("kegg.xlsx")

x1=kegginput$logp
y1=factor(kegginput$Term,levels = kegginput$Term)
p3 = ggplot(kegginput,aes(x1,y1))
p4 = p3 + geom_point(aes(size=Count,color=-0.5*log(pvalue)))+
  scale_color_gradient(low = "BLUE", high = "OrangeRed") +
 # scale_color_gradient(low = "SpringGreen", high = "OrangeRed") +
  theme_bw() +
  theme(panel.border = element_rect(fill=NA,color="black", size=0.5, linetype ="solid"))

p5 = p4 + labs(color=expression(-log[10](pvalue)),
               size="Count",x="",y="",title="")
p5

p5 + p2
