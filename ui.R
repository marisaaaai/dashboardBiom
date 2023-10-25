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
    menuItem("Alpha Diversity", icon = icon("chart-scatter"), tabName = "alpha-div")
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
            h3("Healthy Samples"),
            fluidRow(
              box(),
              box()
            ),
            h3("Schizophrenic Samples"),
            fluidRow(
              box(),
              box()
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

