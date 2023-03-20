library(Seurat)
library(dplyr)
library(org.Hs.eg.db)
library(clusterProfiler)
library(DOSE)
library(SingleCellExperiment)
library(ggplot2)
#library(enrichplot)#GO,KEGG,GSEA
#library(fgsea)
library(singleseqgset)
#library(GSVA)
#library(monocle)
library(stringr)
library(R.utils)
library(ggsci)
R.utils::setOption("clusterProfiler.download.method",'auto') 

## read genes
top_200_genes <- read.csv("./top200_cell_markers_cluster_Fibroblast.csv",header = F)
##############################  GO  ####################################

diff_entrez <- bitr(top_200_genes$V1, 
                    fromType="SYMBOL", 
                    toType="ENTREZID", 
                    OrgDb="org.Hs.eg.db")
#MF:
GO_MF_diff <- enrichGO(gene = diff_entrez$ENTREZID, 
                       keyType = "ENTREZID",
                       OrgDb = org.Hs.eg.db, 
                       ont = "MF", 
                       readable = TRUE,
                       pvalueCutoff  = 0.05,
                       qvalueCutoff =0.05) 
#CC:
GO_CC_diff <- enrichGO(gene = diff_entrez$ENTREZID,
                       keyType = "ENTREZID",
                       OrgDb = org.Hs.eg.db,
                       ont = "CC",
                       readable = TRUE,
                       pvalueCutoff  = 0.05,
                       qvalueCutoff =0.05)
#BP:
GO_BP_diff <- enrichGO(gene = diff_entrez$ENTREZID,
                       keyType = "ENTREZID",
                       OrgDb = org.Hs.eg.db,
                       ont = "BP",
                       readable = TRUE,
                       pvalueCutoff  = 0.05,
                       qvalueCutoff =0.05)
#MF、CC、BP三合一：
GO_all_diff <- enrichGO(gene = diff_entrez$ENTREZID,
                        keyType = "ENTREZID",
                        OrgDb = org.Hs.eg.db,
                        ont = "ALL", #三合一选择“ALL”
                        readable = TRUE,
                        pvalueCutoff  = 0.05,
                        qvalueCutoff =0.05)

write.csv(GO_MF_diff@result, "./GO_MF.csv", row.names = F)
write.csv(GO_CC_diff@result, "./GO_CC.csv", row.names = F)
write.csv(GO_BP_diff@result, "./GO_BP.csv", row.names = F)
write.csv(GO_all_diff@result, "./GO_all.csv", row.names = F)

GO_MF_diff_subset <- subset(GO_MF_diff@result, pvalue<0.05 & p.adjust<0.05 & qvalue < 0.05)
write.csv(GO_MF_diff_subset, "./GO_MF_diff_subset.csv", row.names = F)

GO_CC_diff_subset <- subset(GO_CC_diff@result, pvalue<0.05 & p.adjust<0.05 & qvalue < 0.05)
write.csv(GO_CC_diff_subset, "./GO_CC_diff_subset.csv", row.names = F)

GO_BP_diff_subset <- subset(GO_BP_diff@result, pvalue<0.05 & p.adjust<0.05 & qvalue < 0.05)
write.csv(GO_BP_diff_subset, "./GO_BP_diff_subset.csv", row.names = F)


# save(GO_MF_diff,GO_CC_diff,GO_BP_diff,GO_all_diff,file = c("GO_diff.Rdata"))

#
GO_MF_result <- GO_MF_diff@result
GO_CC_result <- GO_CC_diff@result
GO_BP_result <- GO_BP_diff@result
GO_all_result <- GO_all_diff@result

#
MF <- GO_MF_result[1:20,]
CC <- GO_CC_result[1:20,]
BP <- GO_BP_result[1:20,]

#
mytheme <- theme(axis.title = element_text(size = 5),
                 axis.text = element_text(size = 4),
                 plot.title = element_text(size = 5,
                                           hjust = 0.5,
                                           face = "bold"),
                 legend.title = element_text(size = 5),
                 legend.text = element_text(size = 5),
                 panel.background = element_rect(fill = "transparent"),
                 panel.border = element_rect(fill = "transparent",color = 'black'),
                 panel.grid.major = element_blank(), panel.grid.minor = element_blank())

MF2 <- MF
MF2$Description <- str_trunc(MF$Description,width = 100,side = "right")

CC2 <- CC
CC2$Description <- str_trunc(CC$Description,width = 100,side = "right")

BP2 <- BP
BP2$Description <- str_trunc(BP$Description,width = 100,side = "right")

MF2$term <- factor(MF2$Description,levels = rev(MF2$Description))

CC2$term <- factor(CC2$Description,levels = rev(CC2$Description))

BP2$term <- factor(BP2$Description,levels = rev(BP2$Description))

GO_bar <- function(x){
  y <- get(x)
  ggplot(data = y,
         aes(x = Count,
             y = term,
             fill = -log10(pvalue))) +
    scale_y_discrete(labels = function(y) str_wrap(y, width = 50) ) + #label换行，部分term描述太长
    geom_bar(stat = "identity",width = 0.8) +
    labs(x = "Gene Number",
         y = "Description",
         title = paste0(x," of GO enrichment barplot")) +
    theme_bw() +
    mytheme
}

#MF:
p1 <- GO_bar("MF2")+scale_fill_distiller(palette = "Blues",direction = 1)

#CC:
p2 <- GO_bar("CC2")+scale_fill_distiller(palette = "Reds",direction = 1)

#BP:
p3 <- GO_bar("BP2")+scale_fill_distiller(palette = "Greens",direction = 1)

ggsave("./GO_enrich_MF.pdf", plot = p1, width = 80, height = 60, units = 'mm')

ggsave("./GO_enrich_CC.pdf", plot = p2, width = 80, height = 60, units = 'mm')

ggsave("./GO_enrich_BP.pdf", plot = p3, width = 80, height = 60, units = 'mm')

#############################  wikipathway  ####################################
wp <-  enrichWP(diff_entrez$ENTREZID, organism = "Homo sapiens") 

wp <- setReadable(wp, OrgDb = org.Hs.eg.db, keyType = "ENTREZID")

write.csv(wp@result, "./wikipathway.csv", row.names = F)