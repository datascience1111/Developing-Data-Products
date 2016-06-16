library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Consumer Complaint Data - Bureau of Consumer Financial Protection"),
    
    # Sidebar with controls to select a dataset and specify the
    # number of observations to view
    sidebarLayout(
        sidebarPanel(
            selectInput("dataset", "Choose a consumer complaint dataset:", 
                        choices = c("products", "companies", "timeliness")),
            
            numericInput("obs", "Number of observations to view:", 10)
        ),
        
        # Show a summary of the dataset and an HTML table with the 
        # requested number of observations
        mainPanel(
            verbatimTextOutput("summary"),
            
            tableOutput("view"),
            
            plotOutput("plot")
        )
    )
))

##products, companies, timeliness
##product, companies, df3