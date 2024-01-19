library(ggplot2)
df = read.table("wagyu.CNVRtype_length.txt", sep='\t', header=T)
df$Type <- factor(data$Type, levels=c("DEL", "DUP", "Both"))
df$length <- factor(data$length, levels=c("1-2kb","2-5kb","5-10kb","10-20kb","20-50kb",">50kb"))
phy.cols <- c("#93DAD1","#7290CC", "#9870CB")

ggplot(df, aes(x=length,y= allength, group= Type,fill=Type))+ 
  geom_bar(stat = "identity")+
  labs(x="Distribution", y="Length of CNVRs (Mb)") +
  scale_fill_manual(values=phy.cols) +
  theme_bw() +
  theme(panel.border = element_rect(fill=NA,color="black", linewidth = 0.5, linetype ="solid"))
