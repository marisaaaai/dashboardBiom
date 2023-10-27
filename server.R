#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library("phyloseq")
library("ggplot2")
library("RColorBrewer")
library("patchwork")
library("vegan")
library(shinydashboard)
library(shinyBS)

options(shiny.maxRequestSize=30*1024^2)
# Define server logic required to draw a histogram
function(input, output, session) {
  observe({
    healthy = input$healthy
    schizo = input$schizo
    if (is.null(healthy) || is.null(schizo)) {
      return(NULL)
    }
    healthydata = import_biom(healthy$datapath)
    schizodata = import_biom(schizo$datapath)
    healthydata@tax_table@.Data <- substring(healthydata@tax_table@.Data, 4)
    schizodata@tax_table@.Data <- substring(schizodata@tax_table@.Data, 4)
    colnames(healthydata@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
    colnames(schizodata@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
    unique(healthydata@tax_table@.Data[,"Phylum"])
    unique(schizodata@tax_table@.Data[,"Phylum"])
    
    output$classH <- renderPrint(healthydata)
    output$classS <- renderPrint(schizodata)
    output$richnessH <- renderPlot(plot_richness(physeq = healthydata, measures = c("Shannon","Simpson"))) 
    output$richnessS <- renderPlot(plot_richness(physeq = schizodata, measures = c("Shannon","Simpson"))) 

    healthydata <- subset_taxa(healthydata, Genus !="")
    percentagesH <- transform_sample_counts(healthydata, function(x) x*100 /sum(x))
    meta_ordH <- ordinate(physeq = percentagesH, method = input$method, distance = input$distance)
    schizodata <- subset_taxa(schizodata, Genus !="")
    percentagesS <- transform_sample_counts(schizodata, function(x) x*100 /sum(x))
    meta_ordS <- ordinate(physeq = percentagesS, method = input$method, distance = input$distance)
    
    output$betaH <- renderPlot(plot_ordination(physeq = percentagesH, ordination = meta_ordH))
    output$betaS <- renderPlot(plot_ordination(physeq = percentagesS, ordination = meta_ordS))
    
    #graficas de abundacia absoluta y relativas de las secuencias
    percentages_glomH <- tax_glom(percentagesH, taxrank = 'Phylum')
    percentages_glomS <- tax_glom(percentagesS, taxrank = 'Phylum')
    
    percentages_dfH <-psmelt(percentages_glomH)
    percentages_dfS <-psmelt(percentages_glomS)
    
    absolute_glomH <- tax_glom(physeq = healthydata, taxrank = 'Phylum')
    absolute_glomS <- tax_glom(physeq = schizodata, taxrank = 'Phylum')
    
    absolute_dfH <-psmelt(absolute_glomH)
    absolute_dfS <-psmelt(absolute_glomS)
    
  
    #graficar
    percentages_dfH$Phylum <- as.character(percentages_dfH$Phylum)
    percentages_dfH$Phylum[percentages_dfH$Abundance < input$abundance] <- paste("Phyla < ", input$abundance, "% abund.")
    percentages_dfH$Phylum <- as.factor(percentages_dfH$Phylum)
    phylum_colors_rel <- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_dfH$Phylum)))
    relative_plotH <- ggplot(data = percentages_dfH, aes(x=Sample, y= Abundance,fill=Phylum))+ geom_bar(aes(), stat = "identity",position = "stack") + scale_fill_manual(values = phylum_colors_rel)
    output$arh <- renderPlot(relative_plotH)
    
    percentages_dfS$Phylum <- as.character(percentages_dfS$Phylum)
    percentages_dfS$Phylum[percentages_dfS$Abundance < input$abundance] <- paste("Phyla < ", input$abundance, "% abund.")
    percentages_dfS$Phylum <- as.factor(percentages_dfS$Phylum)
    phylum_colors_rel <- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_dfS$Phylum)))
    relative_plotS <- ggplot(data = percentages_dfS, aes(x=Sample, y= Abundance,fill=Phylum))+ geom_bar(aes(), stat = "identity",position = "stack") + scale_fill_manual(values = phylum_colors_rel)
    output$ars <- renderPlot(relative_plotS)
    
    absolute_dfH$Phylum <- as.factor(absolute_dfH$Phylum)
    phylum_colors_abs <- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(absolute_dfH$Phylum)))
    absolute_plotH <- ggplot(data = absolute_dfH, aes(x=Sample, y= Abundance,fill=Phylum))+ geom_bar(aes(), stat = "identity",position = "stack") + scale_fill_manual(values = phylum_colors_abs)
    output$aah <- renderPlot(absolute_plotH)
    
    absolute_dfS$Phylum <- as.factor(absolute_dfS$Phylum)
    phylum_colors_abs <- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(absolute_dfS$Phylum)))
    absolute_plotS <- ggplot(data = absolute_dfS, aes(x=Sample, y= Abundance,fill=Phylum))+ geom_bar(aes(), stat = "identity",position = "stack") + scale_fill_manual(values = phylum_colors_abs)
    output$aas <- renderPlot(absolute_plotS)

    
  })
  
}
