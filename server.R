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
    
    
  })
  
}
