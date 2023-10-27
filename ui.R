#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Upload Data", tabName = "dashboard", icon = icon("file")),
    menuItem("Alpha Diversity", icon = icon("chart-scatter"), tabName = "alpha-div"),
    menuItem("Beta Diversity", icon = icon("chart-scatter"), tabName = "beta-div"),
    menuItem("Relative and Absolute Abundance", icon = icon("Graph"), tabName = "abundance")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
            h2("Upload Data"),
            fluidRow(
              box( solidHeader = TRUE,
                   # title = "Upload menu",
                   #width = "4",
                   fileInput(
                     "healthy",
                     "Healthy Biom:",
                     multiple = FALSE,
                     accept = c(".biom"), placeholder="Phyloseq .biom files"
                   )              ),
              box( solidHeader = TRUE,
                   # title = "Upload menu",
                   #width = "4",
                   fileInput(
                     "schizo",
                     "Schizophrenic Biom:",
                     multiple = FALSE,
                     accept = c(".biom"), placeholder="Phyloseq .biom files"
                   )              
              )
            ),
            fluidRow(
              box(  title = "File type:", textOutput("classH")),
              box(  title = "File type:", textOutput("classS"))
            )
    ),
    
    tabItem(tabName = "alpha-div",
            h2("Alpha Diversity Graphs"),
            br(),
            fluidRow(
              box(width = 10,title = "Healthy Samples", solidHeader = TRUE, plotOutput("richnessH"))
            ),
            br(),
            fluidRow(
              box(width = 10,title = "Schizophrenic Samples", solidHeader = TRUE,plotOutput("richnessS"))
            )
            
    ),
    tabItem(tabName = "beta-div",
            h2("Beta Diversity Graphs"),
            br(),
            fluidRow(
              box(selectInput("distance", "Distance:",
                              c("Manhattan" = "manhattan",
                                "Euclidean" = "euclidean",
                                "Canberra" = "canberra",
                                "Bray" = "bray",
                                "Horn" = "horn",
                                "Binomial" = "binomial"))),
              box(selectInput("method", "Method:",
                              c("DCA" = "DCA",
                                "CCA" = "CCA",
                                "RDA" = "RDA",
                                "CAP" = "CAP",
                                "DPCoA" = "DPCoA",
                                "NMDS" = "NMDS")))
            ),
            fluidRow(
              box(title = "Healthy Samples", width = 12, plotOutput("betaH")),
              box(title = "Schizophrenic Samples", width = 12, plotOutput("betaS"))
              
            )
            ),
    tabItem(tabName = "abundance",
            h2("Relative and Absolute Abundance"),
            br(),
            fluidRow(box(sliderInput("abundance", "Percentage of Relative Abundance to Filter", value = 0.5, min = 0, max = 1))),
              h3("Healthy Samples"),
            fluidRow(
              box(title = "Absolute Abundance", width = 12, plotOutput("aah"))),
            fluidRow(
              box(title = "Relative Abundance", width = 12, plotOutput("arh"))
            ),
            h3("Schizophrenic Samples"),
            fluidRow(
              box(title = "Absolute Abundance", width = 12, plotOutput("aas"))),
            fluidRow(
              box(title = "Relative Abundance", width = 12, plotOutput("ars"))
            )
            )
  )
)

# Put them together into a dashboardPage
dashboardPage(
  dashboardHeader(title = "Biom Viz"),
  sidebar,
  body
)

