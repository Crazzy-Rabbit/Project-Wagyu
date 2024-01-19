# 数量分布
library(ggplot2)
df = read.table("wagyu_all_dis.txt", sep='\t', header=T)

ggplot(df, aes(y= count, x = Type, fill = Region))+
       geom_bar(stat = "identity", position = "stack")+ 
  theme_minimal()+     
  theme(legend.position = "none") + 
       guides(fill = guide_legend( ncol = 4, byrow = F)) +
       theme(axis.text.y = element_text(face="bold"))+
       theme(axis.text.x = element_text(face="bold"))+
       labs(x="", y="Number of CNVRs") +
  scale_y_continuous(expand = c(0,0))+
  scale_fill_manual(values=m_col)

# 百分比分布
library(ggplot2)
df = read.table("wagyu_all_dis.txt", sep='\t', header=T)
m_col = c("#EEBB47","#93DAD1","#6DB0D7","#9870CB","#C477A6","#2F71A7","#F5E745","#D8793F","#C63581","#6A3D9A")
ggplot(df, aes(x=Type, y=percent, fill= Region))+
  geom_bar(stat = "identity")+ 
  coord_flip()+
  theme_minimal() +
  theme(legend.position = "top") + 
  guides(fill = guide_legend(ncol = 3, byrow = F)) +
  theme(axis.text.y = element_text(face="bold"))+
  theme(axis.text.x = element_text(face="bold"))+
  labs(x="", y="Percentage of CNVRs (%)") +
  scale_y_continuous(expand = c(0,0))+
  scale_fill_manual(values=m_col)
