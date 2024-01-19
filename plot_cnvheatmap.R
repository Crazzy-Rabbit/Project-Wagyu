setwd("D:/百度网盘同步文件/BaiduSyncdisk/21-24吉大硕士/2021-2024毕业设计/22.09.26-牛-毕业/拷贝数/文章")
library(pheatmap)
group = read.table("sample_plot.list.txt", stringsAsFactors = F)
names(group) <- c("ID","Group")
rownames(group) <- group$ID
group$ID <- NULL

data2=read.table ("CNV.txt", header = TRUE, stringsAsFactors = F)
data2=data.matrix(data2)

annotation_row = data.frame(Group=as.vector(group$Group))
rownames(annotation_row) = rownames(data2)
ra_col <- list(Group=c(WAG="#873186", ANG="#E20593", HOL="#6BB93F"))
gap_line <- c(21,41)

pheatmap(data2, annotation_row=annotation_row, border_color=NA, annotation_colors=ra_col,
        cluster_row=FALSE,cluster_col=FALSE,gaps_row=gap_line,legend =FALSE,
        labels_col = rep("",ncol(data2)),labels_row=rep("",nrow(data2)),
        color=c("gold","#6BB93F","grey"), angle_col = "0")
