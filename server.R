library(shiny)
library(ggplot2)
library(dplyr)

complaints <- read.csv("Consumer_Complaints.csv", header = TRUE, sep = ",")
complaints %>% group_by(Product) %>% summarize(count=n())
product <- as.data.frame(complaints %>% group_by(Product) %>% summarize(count=n()))
product <- arrange(product, desc(count))

complaints %>% group_by(Company) %>% summarize(count=n())
companies <- as.data.frame(complaints %>% group_by(Company) %>% summarize(count=n()))
companies <- arrange(companies, desc(count))
companies <- head(companies, 10)

untimely <- complaints[complaints$Timely.response. == "No",]
untimely <- as.data.frame(untimely %>% group_by(Submitted.via) %>% summarize(count=n()))
untimely <- arrange(untimely, desc(count))

timely <- complaints[complaints$Timely.response. == "Yes",]
timely <- as.data.frame(timely %>% group_by(Submitted.via) %>% summarize(count=n()))
timely <- arrange(timely, desc(count))

df3 <- merge(untimely, timely, "Submitted.via")
names(df3) <- c("Submitted.via", "untimely", "timely")

df3$total <- df3$timely + df3$untimely
df3$timely.effective <- df3$timely/df3$total
df3 <- arrange(df3, desc(timely.effective))

# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {
    
    # Return the requested dataset
    datasetInput <- reactive({
        switch(input$dataset,
               "products" = product,
               "companies" = companies,
               "timeliness" = df3)
    })
    
    # Generate a summary of the dataset
    output$summary <- renderPrint({
        dataset <- datasetInput()
        summary(dataset)
    })
    
    # Show the first "n" observations
    output$view <- renderTable({
        head(datasetInput(), n = input$obs)
    })
    
    output$plot <- renderPlot({
        if (input$dataset == "products") {
            barplot(product$count, main = "Products with the most complaints",
                    xlab = "Product type", names.arg = c(product$Product), ylim = c(0,200000))
            
        }
        
        if (input$dataset == "companies") {
            barplot(companies$count, main = "Companies with the most complaints",
                    xlab = "Company", names.arg = c(companies$Company))
                }
        
        if (input$dataset == "timeliness") {
            barplot(df3$timely.effective, main = "Submission method with the best timely response rate",
                    xlab = "Submission method", names.arg = c(df3$Submitted.via))
        }
        
        })
    })

    
