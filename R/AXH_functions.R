#AxH_functions.R
#author: "Mike Connelly"
#date: "05/07/2020"
# Create ggplot2 theme for journal submission
theme_mec <- function(base_size = 10, base_family = "Arial") {
  (theme_foundation(base_size=base_size, base_family=base_family)
   + theme(
     plot.background = element_rect(colour = NA),
     panel.background = element_blank(),
     panel.grid.major = element_blank(), 
     panel.grid.minor = element_blank(), 
     panel.border = element_rect(color = "black", fill = NA),
     plot.title = element_text(face = "plain", size = rel(1), hjust = 0),
     plot.subtitle = element_text(face = "plain", size = rel(0.8)),
     axis.title = element_text(face = "plain",size = rel(1)),
     axis.title.x = element_text(vjust = -2),
     axis.title.y = element_text(angle = 90, vjust = 2),
     text = element_text(),
     axis.text = element_text(size = rel(0.8)), 
     axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 0.5),
     axis.text.y = element_text(), 
     #axis.line = element_line(colour = "black"),
     axis.ticks = element_line(),
     legend.title = element_text(size = rel(1)),
     legend.text = element_text(size = rel(0.8), margin = margin(t = 2, b = 2, unit = "mm")),
     legend.key = element_rect(color = NA),
     legend.background = element_rect(fill = NA, colour = NA),
     legend.position = "right",
     legend.direction = "vertical",
     legend.spacing.x = unit(2, "mm"),
     legend.spacing.y = unit(0, "mm"),
     legend.key.size = unit(2, "mm"),
     plot.margin = unit(c(2,2,2,2), "mm"),
     strip.background = element_rect(color = "black", fill = "grey"),
     strip.text = element_text(face = "plain")
   ))
}
###

# EAPSI AXH Transcriptome Analysis Functions ---------------------------------------------------------------------------------
### PCA plot with custom PC axes----------------------------------------------------------------------------------
plotPCA.custom <-  function(object, intgroup="Treatment", ntop=500, returnData=FALSE, pcs = c(1,2))
{
  stopifnot(length(pcs) == 2)    ### added this to check number of PCs ####
  # calculate the variance for each gene
  rv <- rowVars(assay(object))
  # select the ntop genes by variance
  select <- order(rv, decreasing=TRUE)[seq_len(min(ntop, length(rv)))]
  # perform a PCA on the data in assay(x) for the selected genes
  pca <- prcomp(t(assay(object)[select,]))
  # the contribution to the total variance for each component
  percentVar <- pca$sdev^2 / sum( pca$sdev^2 )
  if (!all(intgroup %in% names(colData(object)))) {
    stop("the argument 'intgroup' should specify columns of colData(dds)")
  }
  intgroup.df <- as.data.frame(colData(object)[, intgroup, drop=FALSE])
  # add the intgroup factors together to create a new grouping factor
  group <- if (length(intgroup) > 1) {
    factor(apply( intgroup.df, 1, paste, collapse=" : "))
  } else {
    colData(object)[[intgroup]]
  }
  # assemble the data for the plot
  ########## Here we just use the pcs object passed by the end user ####
  d <- data.frame(PC1=pca$x[,pcs[1]], PC2=pca$x[,pcs[2]], group=group, intgroup.df, name=colnames(object))
  if (returnData) {
    attr(d, "percentVar") <- percentVar[1:2]
    return(d)
  }
  
  # extract loadings
}

### PCA plot formatted with aesthetics ---------------------------------------------------------------------------
ggPCA <- function(vsd, samples, condcolors, ntop = 500,  pclab = c(1,2)) {
  
  PCAtmtdata <- plotPCA.custom(vsd, intgroup = c("Colony", "Treatment"), ntop = 500, returnData = TRUE,  pcs = c(pclab[1],pclab[2]))
  #set factor orders 
  PCAtmtdata$Colony <- factor(PCAtmtdata$Colony, levels = c("HW1", "HW2", "WT1", "WT2"), ordered = TRUE)
  PCAtmtdata$Treatment <- factor(PCAtmtdata$Treatment, levels = c("control", "Heat", "Antibiotics", "Antibiotics.Heat"), ordered = TRUE)
  
  PCAtmtpercentVar <- round(100* attr(PCAtmtdata, "percentVar"))
  
  PCAplot <-  PCAtmtdata %>% ggplot(aes(PC1,PC2)) +
    geom_point(size=4, aes(fill = Treatment, shape = Colony), color = "black", stroke = 0.5, show.legend = TRUE) +
    xlab(paste0( "PC", pclab[1], ": ", PCAtmtpercentVar[pclab[1]], "% variance")) + 
    ylab(paste0( "PC", pclab[2], ": ", PCAtmtpercentVar[pclab[2]], "% variance")) + 
    coord_fixed(1) + 
    scale_fill_manual(values=condcolors, name="Treatment") + 
    scale_shape_manual(values=colshapes, name="Colony") +
    theme(legend.position = "right") +
    guides(fill = guide_legend(override.aes = list(fill = condcolors, shape = 21, alpha = 1, stroke = 0.5))) +
    ggtitle("Principal Component Analysis")
  
PCAplot
}

### Function to plot color bar -------------------------------------------------------------------------------------
color.bar <- function(lut, min, max=-min, nticks=11, ticks=seq(min, max, len=nticks), title='') {
  scale = (length(lut)-1)/(max-min)
  
  dev.new(width=1.75, height=5)
  plot(c(0,10), c(min,max), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='', main=title)
  axis(2, ticks, las=1)
  for (i in 1:(length(lut)-1)) {
    y = (i-1)/scale + min
    rect(0,y,10,y+1/scale, col=lut[i], border=NA)
  }	
}

### Volcano plot for differential gene expression -----------------------------------------------------------------
volcanoplot <- function(res) {
  
  ##Highlight genes that have a padj < 0.05
  res$threshold <- ifelse(res$padj < 0.05 & res$log2FoldChange > 0, "Upregulated", ifelse(res$padj < 0.05 & res$log2FoldChange < 0, "Downregulated", "NA"))
  res$log10padj <- -log10(res$padj)
  dat_genes <- data.frame(cbind(res$log2FoldChange, res$log10padj, res$threshold), stringsAsFactors = FALSE)
  colnames(dat_genes) <- c("log2FoldChange", "log10padj", "threshold")
  row.names(dat_genes) <- res$IDGeneInfo
  #dat_genes <- dat_genes[order(dat_genes$log2FoldChange, decreasing = TRUE),]
  dat_genes$log2FoldChange <- as.numeric(dat_genes$log2FoldChange)
  dat_genes$log10padj <- as.numeric(dat_genes$log10padj)
  dat_genes$threshold <- factor(dat_genes$threshold, levels = c("Upregulated", "Downregulated", "NA"), ordered = TRUE)
  #Create volcanoplot
  gVolcano <- dat_genes %>% 
    ggplot(aes(log2FoldChange, log10padj)) + 
    geom_point(aes(color = threshold), alpha=0.7, size=2) +
    scale_color_manual(values = DEGcolors) +
    scale_x_continuous(limits = c(-6,6), breaks = seq(-10,10,2)) + 
    ylim(c(0, 10)) +
    xlab("log2 fold change") +
    ylab("-log10 p-value") + 
    #geom_text_repel(data = dat_genes_LPS_ctrl[1:15, ], aes(label = rownames(dat_genes_LPS_ctrl[1:15, ])), color = "black", size = 2.5, box.padding = unit(0.35, "lines")) +
    theme_bw() +
    theme(legend.position = "none", 
          plot.title = element_text(size = 12, hjust = 0, vjust = 1),
          axis.text = element_text(size = 10),
          axis.title = element_text(size = 10))
  print(gVolcano)
}

### Gene expression boxplot functions ------------------------------------------------------------------------------------
ggboxplot <- function(gene) {
  plotTitle <- gene_annotation %>% filter(ID == gene) %>% select(Gene_Info)
  subTitle <- gene
  df <- plotCounts(dds, gene = gene, intgroup = "Treatment", returnData = TRUE)
  df$Treatment <- factor(df$Treatment, levels = c("control", "Heat", "Antibiotics", "Antibiotics.Heat"), ordered = TRUE)
  gbplot <- df %>% ggplot(aes(x = Treatment, y = count, color = Treatment, fill = Treatment)) +
    geom_boxplot(show.legend = FALSE) + 
    geom_point(aes(shape = samples$Colony), size = 2, show.legend = FALSE) +
    scale_color_manual(values = condcolors_AxH) +
    scale_fill_manual(values = condfillcolors_AxH) +
    scale_shape_manual(values = colshapes) +
    scale_y_continuous(trans = log2_trans(),
                       breaks = trans_breaks("log2", function(x) 2^x),
                       labels = trans_format("log2", math_format(2^.x))) +
    ggtitle(plotTitle, subtitle = subTitle)
  print(gbplot)
}


genoboxplot <- function(gene) {
  plotTitle <- gene_annotation %>% filter(ID == gene) %>% select(Gene_Info)
  subTitle <- gene
  df <- plotCounts(dds, gene = gene, intgroup = "Treatment", returnData = TRUE)
  df$Treatment <- factor(df$Treatment, levels = c("control", "Heat", "Antibiotics", "Antibiotics.Heat"), ordered = TRUE)
  gbplot <- df %>% ggplot(aes(x = Treatment, y = count, color = Treatment)) +
    geom_boxplot(aes(fill = Treatment), show.legend = FALSE) + 
    geom_point(aes(shape = samples$Colony), size = 2, show.legend = FALSE) +
    facet_grid(.~samples$Colony) +
    ### add interaction line between genotypes
    stat_summary(fun=mean, geom="path", colour="black", size=0.8, aes(group = samples$Colony)) +
    stat_summary(fun=mean, geom="point", colour="black", size=3, aes(shape = samples$Colony, group = samples$Colony), show.legend = FALSE) +
    ###
    scale_color_manual(values = condcolors_AxH) +
    scale_fill_manual(values = condfillcolors_AxH) +
    scale_shape_manual(values = colshapes) +
    scale_y_continuous(trans = log2_trans(),
                       breaks = trans_breaks("log2", function(x) 2^x),
                       labels = trans_format("log2", math_format(2^.x))) +
    ggtitle(plotTitle, subtitle = subTitle)
  print(gbplot)
  ###
  g_bplot <- ggplot_gtable(ggplot_build(gbplot))
  strip_both <- which(grepl('strip-', g_bplot$layout$name))
  k <- 1
  for (i in strip_both) {
    j <- which(grepl('rect', g_bplot$grobs[[i]]$grobs[[1]]$childrenOrder))
    g_bplot$grobs[[i]]$grobs[[1]]$children[[j]]$gp$fill <- colcolors[k]
    k <- k+1
  }
  gbp <- grid.draw(g_bplot)
  print(gbp)
}

### Function to plot GO_MWU clustering ---------------------------------------------------------------------------


### Functions to plot KOG delta ranks heatmap ---------------------------------------------------------------------
#from https://stackoverflow.com/questions/15505607/diagonal-labels-orientation-on-x-axis-in-heatmaps
draw_main <- function (text, ...) 
{
  res = textGrob(text, gp = gpar(fontface = "plain", ...), hjust = 0)
  return(res)
}
#overwrite default draw_main with left-justified version 
assignInNamespace(x="draw_main", value="draw_main",
                  ns=asNamespace("pheatmap"))

draw_colnames_330 <- function (coln, gaps, ...) {
  coord = pheatmap:::find_coordinates(length(coln), gaps)
  x = coord$coord - 0.5 * coord$size
  res = textGrob(coln, x = x, y = unit(1, "npc") - unit(3,"bigpts"), vjust = 1, hjust = 0, rot = 330, gp = gpar(...))
  return(res)}

assignInNamespace(x="draw_colnames", value="draw_colnames_330",
                  ns=asNamespace("pheatmap"))

KOGheatmap <- function(deltaranks, pvals, ...) {
  deltaranks <- as.matrix(deltaranks)
  paletteLength <- 100
  myColor <- colorRampPalette(rev(c("red", "yellow", "grey10", "cyan", "blue")))(paletteLength)
  myBreaks <- c(seq(min(deltaranks), 0, length.out = ceiling(paletteLength/2) + 1), 
                seq(max(deltaranks)/paletteLength, max(deltaranks), 
                    length.out = floor(paletteLength/2)))
  pheatmap(mat = deltaranks, display_numbers = pvals,
           cluster_cols = FALSE, cluster_rows = FALSE,
           treeheight_row = 15, treeheight_col = 15,
           border_color = "white", scale = "none",
           color = myColor, breaks = myBreaks, ...)
}

# EAPSI AXH Microbiome Analysis Functions ---------------------------------------------------------------------------------
### Center log-ratio PCA biplot function 
# altered ggbiplot function - shorted axis labels, aesthetics, and variable labels
gg_biplot <- function (pcobj, choices = 1:2, scale = 1, pc.biplot = TRUE, 
                       obs.scale = 1 - scale, var.scale = scale, groups = NULL, groups2 = NULL, 
                       ellipse = FALSE, ellipse.prob = 0.68, labels = NULL, labels.size = 3, 
                       alpha = 1, var.axes = TRUE, circle = FALSE, circle.prob = 0.69, 
                       varname.size = 3, varname.adjust = 1.5, varname.abbrev = FALSE, taxlabs = NULL,
                       ...) 
{
  library(ggplot2)
  library(plyr)
  library(scales)
  library(grid)
  stopifnot(length(choices) == 2)
  if (inherits(pcobj, "prcomp")) {
    nobs.factor <- sqrt(nrow(pcobj$x) - 1)
    d <- pcobj$sdev
    u <- sweep(pcobj$x, 2, 1/(d * nobs.factor), FUN = "*")
    v <- pcobj$rotation
  }
  else if (inherits(pcobj, "princomp")) {
    nobs.factor <- sqrt(pcobj$n.obs)
    d <- pcobj$sdev
    u <- sweep(pcobj$scores, 2, 1/(d * nobs.factor), FUN = "*")
    v <- pcobj$loadings
  }
  else if (inherits(pcobj, "PCA")) {
    nobs.factor <- sqrt(nrow(pcobj$call$X))
    d <- unlist(sqrt(pcobj$eig)[1])
    u <- sweep(pcobj$ind$coord, 2, 1/(d * nobs.factor), FUN = "*")
    v <- sweep(pcobj$var$coord, 2, sqrt(pcobj$eig[1:ncol(pcobj$var$coord), 
                                                  1]), FUN = "/")
  }
  else if (inherits(pcobj, "lda")) {
    nobs.factor <- sqrt(pcobj$N)
    d <- pcobj$svd
    u <- predict(pcobj)$x/nobs.factor
    v <- pcobj$scaling
    d.total <- sum(d^2)
  }
  else {
    stop("Expected a object of class prcomp, princomp, PCA, or lda")
  }
  choices <- pmin(choices, ncol(u))
  df.u <- as.data.frame(sweep(u[, choices], 2, d[choices]^obs.scale, 
                              FUN = "*"))
  v <- sweep(v, 2, d^var.scale, FUN = "*")
  df.v <- as.data.frame(v[, choices])
  names(df.u) <- c("xvar", "yvar")
  names(df.v) <- names(df.u)
  if (pc.biplot) {
    df.u <- df.u * nobs.factor
  }
  r <- sqrt(qchisq(circle.prob, df = 2)) * prod(colMeans(df.u^2))^(1/4)
  v.scale <- rowSums(v^2)
  df.v <- r * df.v/sqrt(max(v.scale))
  if (obs.scale == 0) {
    u.axis.labs <- paste("PC", choices, sep = "")
  }
  else {
    u.axis.labs <- paste("PC", choices, sep = "")
  }
  u.axis.labs <- paste(u.axis.labs, sprintf("(%0.1f%%)", 
                                            100 * pcobj$sdev[choices]^2/sum(pcobj$sdev^2)))
  if (!is.null(labels)) {
    df.u$labels <- labels
  }
  if (!is.null(groups)) {
    df.u$groups <- groups
  }
  if (varname.abbrev) {
    df.v$varname <- abbreviate(rownames(v))
  }
  else {
    df.v$varname <- as.character(taxonomy[rownames(v), taxlabs])
    # rownames(v) # can make change here to get taxa level names
  }
  df.v$angle <- with(df.v, (180/pi) * atan(yvar/xvar))
  df.v$hjust = with(df.v, (1 - varname.adjust * sign(xvar))/2)
  g <- ggplot(data = df.u, aes(x = xvar, y = yvar)) + xlab(u.axis.labs[1]) + 
    ylab(u.axis.labs[2]) + coord_fixed()
  if (var.axes) {
    if (circle) {
      theta <- c(seq(-pi, pi, length = 50), seq(pi, -pi, 
                                                length = 50))
      circle <- data.frame(xvar = r * cos(theta), yvar = r * 
                             sin(theta))
      g <- g + geom_path(data = circle, color = muted("white"), 
                         size = 1/2, alpha = 1/3)
    }
    g <- g + geom_segment(data = df.v, aes(x = 0, y = 0, 
                                           xend = xvar, yend = yvar), arrow = arrow(length = unit(1/2, 
                                                                                                  "picas")), color = "grey")
  }
  if (!is.null(df.u$groups) && ellipse) {
    theta <- c(seq(-pi, pi, length = 50), seq(pi, -pi, length = 50))
    circle <- cbind(cos(theta), sin(theta))
    ell <- ddply(df.u, "groups", function(x) {
      if (nrow(x) <= 2) {
        return(NULL)
      }
      sigma <- var(cbind(x$xvar, x$yvar))
      mu <- c(mean(x$xvar), mean(x$yvar))
      ed <- sqrt(qchisq(ellipse.prob, df = 2))
      data.frame(sweep(circle %*% chol(sigma) * ed, 2, 
                       mu, FUN = "+"), groups = x$groups[1])
    })
    names(ell)[1:2] <- c("xvar", "yvar")
    g <- g + geom_path(data = ell, aes(color = groups, group = groups))
  }
  if (!is.null(df.u$labels)) {
    if (!is.null(df.u$groups)) {
      g <- g + geom_text(aes(label = labels, color = groups), 
                         size = labels.size)
    }
    else {
      g <- g + geom_text(aes(label = labels), size = labels.size)
    }
  }
  else {
    if (!is.null(df.u$groups)) {
      g <- g + geom_point(aes(fill = groups, shape = groups2), size = 3, alpha = alpha)
    }
    else {
      g <- g + geom_point(alpha = alpha)
    }
  }
  if (var.axes) {
    g <- g + geom_text(data = df.v, aes(label = varname, 
                                        x = xvar, y = yvar,
                                        angle = angle,
                                        hjust = hjust), 
                       color = "black", size = varname.size)
  }
  return(g)
}

### function for getting ordered dataframe with color assignments based on chose taxonomic ranks
taxa_color_seq <- function(physeq, taxa_rank) {
  glom <- tax_glom(physeq, taxrank = taxa_rank)
  psmelted <- psmelt(glom)
  psmelted[, taxa_rank] <- as.character(psmelted[ , taxa_rank])
  psmelted[psmelted$Abundance < 0.01, taxa_rank] <- "<1% abundance"
  # 
  taxa_rank_name <- sym(taxa_rank)
  taxa_colors_table <- psmelted %>% 
    group_by({{ taxa_rank_name }}) %>% 
    summarise(cum_rel_ab = sum(Abundance)/48) %>% 
    arrange(cum_rel_ab) %>% 
    filter({{ taxa_rank_name }} != "<1% abundance")
  # 
  lowtaxa <- data.frame("<1% abundance", 0)
  colnames(lowtaxa) <- colnames(taxa_colors_table)
  taxa_colors_df <- rbind(lowtaxa, taxa_colors_table)
  # 
  taxa_colors_df$hex <-  distinctColorPalette(length(taxa_colors_df$cum_rel_ab))
  taxa_colors_df$colors <- sapply(taxa_colors_df$hex, color.id)
  taxa_colors_df[1, c(3,4)] <- c("#D3D3D3", "lightgrey")
  taxa_colors_df
}
# somehow broken on 8/6/20, unbroken 8/7/20

### Taxa barplot function with colored facet strips, taxa ordered according to cumulative relative abundance and distinct color scheme
taxa_barplot <- function(physeq, taxa_rank, taxa_levels, taxa_colors) {
  glom <- tax_glom(physeq, taxrank = taxa_rank)
  psmelted <- psmelt(glom)
  psmelted[, taxa_rank] <- as.character(psmelted[ , taxa_rank])
  psmelted[psmelted$Abundance < 0.01, taxa_rank] <- "<1% abundance"
  psmelted[, taxa_rank] <- factor(psmelted[, taxa_rank], levels = taxa_levels, ordered = TRUE)
  
  # all samples facetted according to treatment
  barplot <- ggplot(data = psmelted, aes(x = Sample, y = Abundance, fill = psmelted[, taxa_rank]))
  barplot <- barplot +
    geom_bar(aes(), stat = "identity") +
    facet_nested(. ~ Treatment + Colony, scales = "free_x", space = "free", switch = NULL) +
    scale_fill_manual(values = taxa_colors$hex) +
    ylab("Relative Abundance") +
    guides(fill = guide_legend(nrow = 4))
  barplot <- barplot +
    theme(axis.text.x = element_blank(), 
          axis.ticks = element_blank(),
          axis.title.x = element_blank(),
          strip.text = element_text(size = 8),
          strip.placement = "outside",
          # strip.background = element_rect(color = "white", fill = "white"),
          # panel.border = element_rect(color = "white"),
          legend.text = element_text(size = 6),
          legend.title = element_blank(),
          legend.position = "bottom",
          legend.key.width = unit(5.5, "mm"),
          legend.key.height = unit(5, "mm"))
  print(barplot)
  # modify facet strip colors
  gt <- ggplotGrob(barplot)
  strip_both <- which(grepl('strip-', gt$layout$name))
  k <- 1
  for (i in strip_both) {
    j <- which(grepl('rect', gt$grobs[[i]]$grobs[[1]]$childrenOrder))
    gt$grobs[[i]]$grobs[[1]]$children[[j]]$gp$fill <- cond_col_colors[k]
    k <- k+1
  }
  # draw gtable object
  gp <- grid.draw(gt)
  print(gp)
}

### PCoA plot with spiders aesthetics
pcoa_spider <- function(ps, ord, centroids, type = "sample", axes = c(1,2)) {
  pcoa <- plot_ordination(ps, ord, type, axes) +
    #treatment ellipses
    #stat_ellipse(aes(color = Treatment, fill = Treatment), geom = "polygon", type = "norm", alpha = 0.0) + 
    #sample-centroid spiders paths
    geom_segment(data = centroids, mapping = aes(x = `Axis.1`, y = `Axis.2`, xend = c1, yend = c2),
                 lwd = 0.25, col = "dark grey") +
    #treatment centroid points
    geom_point(data = centroids, size = 4, aes(x = c1, y = c2, color = Treatment), fill = "black", shape = 21, stroke = 2, show.legend = TRUE) +
    #sample points
    geom_point(size = 3, aes(fill = Treatment, shape = Colony), color = "black", stroke = 0.5, show.legend = FALSE) +
    scale_color_manual(values = condcolors_AxH, name = "Treatment") +
    scale_fill_manual(values = condcolors_AxH, name = "Treatment") +
    scale_shape_manual(values = colshapes, name = "Colony") + 
    labs(x = "PC1", y = "PC2") +
    guides(shape = guide_legend(override.aes = list(shape = colshapes, alpha = 1, stroke = 0.5))) +
    theme(legend.spacing.y = unit(0, "cm"))
  return(pcoa)
}

### ALDEx2 MA and MW plots ggplot2 for bacteria differential abundance
aldex.plot_gg <- function (x, ..., type = c("MW", "MA"), xlab = NULL, ylab = NULL, 
                           xlim = NULL, ylim = NULL,
                           rare = 0, cutoff = 0.1,
                           all.col = rgb(0, 0, 0, 0.2), called.col = "red", rare.col = "black",
                           pointsize = 3,
                           thres.line.col = "darkgrey", test = "welch") 
{
  type <- match.arg(type)
  if (length(x$effect) == 0) 
    stop("Please run aldex.effect before plotting")
  if (test == "welch") {
    if (length(x$we.eBH) == 0) 
      stop("Welch's t test results not in dataset")
    called <- x$we.eBH <= cutoff
  }
  else if (test == "wilcox") {
    if (length(x$wi.eBH) == 0) 
      stop("Wilcoxon test results not in dataset")
    called <- x$wi.eBH <= cutoff
  }
  if (test == "glm") {
    if (length(x$glm.eBH) == 0) 
      stop("glm test results not in dataset")
    called <- x$glm.eBH <= cutoff
  }
  if (test == "kruskal") {
    if (length(x$kw.eBH) == 0) 
      stop("Kruskall-Wallace test results not in dataset")
    called <- x$kw.eBH <= cutoff
  }
  if (type == "MW") {
    if (is.null(xlab)) 
      xlabel <- expression("Median" ~ ~Log[2] ~ ~"win-Condition diff")
    if (is.null(ylab)) 
      ylabel <- expression("Median" ~ ~Log[2] ~ ~"btw-Condition diff")
    x$asv.type <- ifelse(x$rab.all < rare, "rare", ifelse(x$we.eBH < cutoff, "called", "all"))
    ggaldex_mw <- ggplot(data = x, aes(x = diff.win, y = diff.btw, color = asv.type)) +
      geom_point(size = pointsize) +
      geom_abline(aes(intercept = 0, slope = 1), linetype = "dashed", color = thres.line.col) +
      geom_abline(aes(intercept = 0, slope = -1), linetype = "dashed", color = thres.line.col) +
      scale_x_continuous() +
      scale_y_continuous() +
      scale_color_manual(name = "ASV Type", values = c(all.col, called.col, rare.col)) +
      xlab(xlabel) +
      ylab(ylabel)
    return(ggaldex_mw)
  }
  if (type == "MA") {
    if (is.null(xlab)) 
      xlabel <- expression("Median" ~ ~Log[2] ~ ~"relative abundance")
    if (is.null(ylab)) 
      ylabel <- expression("Median" ~ ~Log[2] ~ ~"btw-Condition diff")
    x$asv.type <- ifelse(x$rab.all < rare, "rare", ifelse(x$we.eBH < cutoff, "called", "all"))
    ggaldex_ma <- ggplot(x, aes(x = rab.all, y = diff.btw, color = asv.type)) +
      geom_point(size = pointsize) +
      scale_x_continuous() +
      scale_y_continuous() +
      scale_color_manual(name = "ASV Type", values = c(all.col, called.col, rare.col)) +
      xlab(xlabel) +
      ylab(ylabel)
    return(ggaldex_ma)
  }
}


