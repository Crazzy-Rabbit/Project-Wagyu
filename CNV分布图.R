## CNV文章
# 变异注释分布
library(ggplot2)
library(ggbreak)# 480 360
data = read.table("3-anno.txt", sep='\t', header=T)
data$Region <- factor(data$Region, level=c("ncRNA_splicing","splicing","UTR5","ncRNA_exonic","UTR3","upstream",
                                           "downstream","ncRNA_intronic","exonic","intronic","intergenic"))
data$Type <- factor(data$Type, level=c("Both", "DUP", "DEL"))
m_col = c("#93DAD1","#7290CC", "#9870CB")

ggplot(data, aes(y= count, x = Region, fill = Type))+ 
  geom_bar(stat = "identity", position = "stack")+ 
  theme_classic()+     
  theme(legend.position = "top") + 
  theme(axis.text.y = element_text(face="bold"))+
  theme(axis.text.x = element_text(face="bold"))+
  labs(x="", y="Number of CNVRs") +
  theme(axis.text.x.top=element_blank(),axis.line.x.top=element_blank(),
        axis.text.x = element_text(face="bold",angle=45, hjust = 1))+
  theme(axis.text.y.right=element_blank(),axis.ticks.y.right=element_blank(),
        axis.text.y = element_text(face="bold"))+
  scale_y_continuous(expand = c(0,0))+
  scale_y_break(c(50,140),space=0.2,
                scales=1.5,expand=c(0,0))+
  scale_fill_manual(values=m_col)+
  guides(fill=guide_legend(title=NULL, byrow=F))

## 注释分布百分比
library(ggplot2) # 480 360
df = read.table("3-anno.txt", sep='\t', header=T)
df$Type <- factor(df$Type, level=c("DEL", "DUP", "Both"))

m_col = c("#EEBB47","#93DAD1","#6DB0D7","#9870CB","#C477A6",
          "#2F71A7","#F5E745","#D8793F","#C63581","#6A3D9A")

ggplot(df, aes( x = Type, y=percent, fill = Region))+
  geom_bar(stat = "identity")+ 
  coord_flip()+
  guides(fill=guide_legend(title=NULL, ncol = 4, byrow = F)) +
  theme_minimal() +
  theme(legend.position = "top") + 
  theme(axis.text.y = element_text(face="bold"))+
  theme(axis.text.x = element_text(face="bold"))+
  labs(x="", y="Percentage of CNVRs (%)") +
  scale_y_continuous(expand = c(0,0))+
  scale_fill_manual(values=m_col)

# 长度分布
library(ggplot2) # 570 360
df = read.table("distrabution.txt", sep='\t', header=T)
df$Type <- factor(df$Type, levels=c("DEL", "DUP", "Both"))
df$length <- factor(df$length, levels=c("1-2kb","2-5kb","5-10kb","10-20kb","20-50kb","50-100kb",">100kb"))
phy.cols <- c("#93DAD1","#7290CC", "#9870CB")

ggplot(df, aes(x=length,y= allength, group= Type,fill=Type))+ 
  geom_bar(stat = "identity")+ ## 添加柱子
  labs(x="CNV size", y="Length of CNVRs (Mb)") +
  scale_fill_manual(values=phy.cols) +
  theme_bw() +
  theme(panel.border = element_rect(fill=NA,color="black", linewidth = 0.5, linetype ="solid")) 

# 数量分布，折线图
library(ggplot2)
library(ggalt) # 590 300
df = read.table("distrabution.txt", sep='\t', header=T)
df$Type <- factor(df$Type, levels=c("DEL", "DUP", "Both"))
df$length <- factor(df$length, levels=c("1-2kb","2-5kb","5-10kb","10-20kb","20-50kb","50-100kb",">100kb"))
phy.cols <- c( "#349839","#EA5D2D","#2072A8")

ggplot(df,aes(x=length,y=num,
                group=Type, colour=Type )) +
  geom_point(size=3)+
  labs(x="CNV size", y="Number of CNVRs")+
  geom_xspline(spline_shape = -0.5)+
  scale_x_discrete(limits=c("1-2kb","2-5kb","5-10kb","10-20kb","20-50kb","50-100kb",">100kb"))+
  scale_colour_manual(values=phy.cols) +
  theme_bw() +
  theme(panel.border = element_rect(fill=NA,color="black", linewidth = 0.5, linetype ="solid"))
