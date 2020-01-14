#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(DT)
# verinin indirilmesi
ptfsmf <- readRDS(url("https://github.com/acikenerji/verianalizi101/blob/master/duzenlenmis_ptfsmf.rds?raw=true"))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("2019 YILI PİYASA TAKAS FİYATI - SİSTEM MARJİNAL FİYATI VERİSİ"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            ("İncelemek istediğiniz veriyi ve tarihi seçiniz."),
            selectInput("variableIn", "1. İncelemek istediğiniz değişkeni seçiniz." , 
                        choices=c("Hepsi", "PTF", "SMF"), selected="Hepsi"),
            dateRangeInput("dateIn", 
                      "2. İncelemek istediğiniz tarih aralığını seçiniz.",
                      start=min(ptfsmf$Tarih),
                      end=max(ptfsmf$Tarih),
                      min=min(ptfsmf$Tarih), 
                      max=max(ptfsmf$Tarih), 
                      format="dd/mm/yyyy", 
                      separator="ve",
                      language="tr",
                      weekstart=1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           tabsetPanel(type = "tab", 
                       tabPanel("Grafik", plotOutput("plot1")),
                       tabPanel("Veri Seti Özeti", verbatimTextOutput("summary")),
                       tabPanel(title = "Ham Veri", dataTableOutput("data", height = "500px"))
                       
                       ),
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$plot1 <- renderPlot({
        
        # verinin grafik icin düzenlenmesi
        ptfsmf <- ptfsmf %>% mutate(Saat = hour(Tarih), Tarih = as.Date(Tarih)) %>%
                             pivot_longer(cols = PTF:SMF, names_to = "Degisken", values_to = "Fiyat")
        
        pl_df <- ptfsmf %>% 
                 filter(Tarih >= input$dateIn[1] & Tarih <= input$dateIn[2]) %>%
                 group_by(Degisken, Saat) %>%
                 summarise(Fiyat = mean(Fiyat))
        
        if(input$variableIn != "Hepsi"){
            pl_df <- pl_df %>% filter(Degisken == input$variableIn)
            ggplot(pl_df, aes(x=Saat, y=Fiyat, color=Degisken)) +
                geom_line() +
                theme_minimal() +
                scale_x_discrete(limits=c(0:23)) +
                labs(title = "Saatlere Göre Fiyatlar - Çizgi Grafiği") +
                theme(axis.text.x = element_text(angle = 45), legend.position = "bottom", 
                      legend.title = element_blank())
        }
        else{
            ggplot(pl_df, aes(x=Saat, y=Fiyat, color=Degisken)) +
                geom_line() +
                theme_minimal() +
                scale_x_discrete(limits=c(0:23)) +
                labs(title = "Saatlere Göre Fiyatlar - Çizgi Grafiği") +
                theme(axis.text.x = element_text(angle = 45), legend.position = "bottom", 
                      legend.title = element_blank())
        }

   
    })
    
    output$data <- renderDataTable({
        ptfsmf$Tarih <- as.character(ptfsmf$Tarih)
        
        ptfsmf <- ptfsmf %>% filter(Tarih >= input$dateIn[1] & Tarih <= input$dateIn[2]) %>% 
                             select(Tarih, PTF, SMF)
        
        if(input$variableIn != "Hepsi"){
            ptfsmf <- ptfsmf %>% select(Tarih, input$variableIn)
            datatable(ptfsmf)
        }
        else
            datatable(ptfsmf)
    })
    
    output$summary <- renderPrint({
        
        ptfsmf <- ptfsmf %>% 
                     mutate(Tarih_temp = as.Date(Tarih)) %>% 
                     filter(Tarih_temp >= input$dateIn[1] & Tarih_temp <= input$dateIn[2]) %>%
                     select(-c(Tarih_temp, NDF, PDF))
        
        if(input$variableIn != "Hepsi"){
            ptfsmf <- ptfsmf %>% select(Tarih, input$variableIn)
            summary(ptfsmf)
        }
        else
            summary(ptfsmf)
        
    })
    
    

}

# Run the application 
shinyApp(ui = ui, server = server)
