#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(lime)
library(tidyverse)
library(MASS)
library(caret)
library(dplyr)
library(ranger)
library(shinycssloaders)



rm(list = ls())


mod <- readRDS("model/randomforest.rds")
dat <- read.csv("data_train/train_dat.csv")[,c(-1,-12)]
dat$education <- as.factor(dat$education)
dat$department <- as.factor(dat$department)
dat$gender <- as.factor(dat$gender)
dat$recruitment_channel <- as.factor(dat$recruitment_channel)
dat$awards_won. <- as.factor(dat$awards_won.)
departments <- c("Analytics", "Finance", "HR", "Legal", "Operations", "Procurement","R&D","Sales & Marketing","Technology")
education <- c("Bachelor's","Below Secondary","Master's & above")
gender <- c("f","m")
awards_won. <- c("No","Yes")
recruitment_channel <- c("other","referred","sourcing")
# Define UI for application that draws a histogram
div(class="loading")
ui <- fluidPage(
    tags$style(
        ".first-p {
      border: 2px solid skyblue;
      font-weight: bold;
      margin: 3px;
      font-style: italic;
      background-color: lightblue;
      text-align:center;
    }"
    ),
    # Application title
    titlePanel("Employee Promotion Evaluation System"),
    p(class = "first-p", "Welcome to Employee Promotion Evaluation System! Please wait a minute for the model results."),
    
    # Sidebar with a slider input for age
    sidebarLayout(
        sidebarPanel(
            radioButtons("department", "Employee's department:", departments),
            radioButtons("education", "Employee's education level:", education),
            radioButtons("gender", "Employee's gender:", gender),
            radioButtons("recruitment_channel", "Employee's recruitment channel:", recruitment_channel),
            radioButtons("awards_won.", "If Employee has awards:", awards_won.),
            sliderInput("no_of_trainings",
                        "Employee's number of trainings:",
                        min = 0,
                        max = 30,
                        value = 30),
            numericInput("previous_year_rating", " Employee's previous year rating:", 1, min = 1, max = 100),
        numericInput("length_of_service", " Employee's length of service (Year):", 1, min = 0, max = 60),
numericInput("avg_training_score", " Employee's avgerage training score:", 60, min = 0, max = 100),
        sliderInput("age",
                        "Employee's Age:",
                        min = 1,
                        max = 80,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            shinycssloaders::withSpinner(
                plotOutput("distPlot")
            ),
            htmlOutput("Explaination"),
            textOutput("contect")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        dat1 <- data.frame(department=as.factor(input$department),education=as.factor(input$education),gender=as.factor(input$gender),recruitment_channel=as.factor(input$recruitment_channel),no_of_trainings=as.numeric(input$no_of_trainings),age=as.numeric(input$age),previous_year_rating=as.numeric(input$previous_year_rating),length_of_service=as.numeric(input$length_of_service),awards_won.=as.factor(input$awards_won.),avg_training_score=as.numeric(input$avg_training_score))
        explainer <- lime(dat,mod)
        e <- lime::explain(dat1,explainer,n_labels = 1,n_features=4)
        plot_features(e)
    })
    output$Explaination <- renderText(
        "<b>Before reviewing the above plot as the evaluation results, please see following explainations:<b>"
    )
    output$contect <- renderText(
        "This plot includes label which is the prediction result and top 5 features influencing this prediction result."
    )
}

# Run the application 
shinyApp(ui=ui,server=server, options=list(port=8080, host="0.0.0.0"))
