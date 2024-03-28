library(shiny)


shinyUI(fluidPage(
  titlePanel(h1("Cas modélisation non linéaire")),
  sidebarLayout(
   sidebarPanel(
     h4("hyperparameters"),
     sliderInput("degre",
                 label = "Select a degre",
                 min = 1,
                 max = 5,
                 value = 1),
     radioButtons("NonLin",
                  label = "NonLinear / Splines",
                  selected = 1,
                  choices = c("Nonlinear" = 1, "Splines" = 2))
   ),
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Data",
                 fluidRow(
                   column(width = 12,
                          p("Les données décrivent la perte de poids d'un patient obèse en fonction du nombre de jours. 
                   Nous avons la perte de poids", em("(weight)"), "comme variable à expliquer et le nombre de jours",em("(Days)"),"
                   comme variable explicative.")),
                   column(width = 12, verbatimTextOutput("summary")),
                   column(width = 12, tabPanel("Plot", plotOutput("distPlot")))
                 )
                 ),

        tabPanel(title="Linear Model",
          fluidRow(
            column(width = 12, verbatimTextOutput("model_output")),
            column(width = 12, plotOutput("model_graph"))
          )
        ),
        tabPanel(title="Multi-Linear Model",
                 fluidRow(
                   column(width = 12, verbatimTextOutput("model_output1")),
                   column(width = 6, plotOutput("model_graph1")),
                   column(width = 6, plotOutput("model_graph2"))
                 )
        ),
        tabPanel(title="NonLinear Model",
                 fluidRow(
                   column(width = 12, verbatimTextOutput("model_output2")),
                   column(width = 12, plotOutput("model_graph3")),
                   # column(width = 6, plotOutput("model_graph4"))
                 )
        )
      )
    )
  )
))
