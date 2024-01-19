
library(CMplot)
data <- read.table("wagyu_angus.vst.Vst.txt",header = T,sep = '\t') 
color_set <- c('#4871B4', '#E0804B')
CMplot(data, plot.type="m", LOG10=F,
       chr.den.col=NULL, col = color_set,
       threshold = 0.5, threshold.col = "red", 
       threshold.lwd= 2, threshold.lty =1,
       amplify = FALSE, file.output=T, height=5, width = 15,
       ylab = expression(paste(italic('V'),st)),
       pch =16, cex =0.5, dpi = 600, file = "jpg",memo = "angus")
