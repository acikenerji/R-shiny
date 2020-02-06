library(shiny)
# Kullanıcı arayüzünün tanımlanması
ui <- fluidPage(
  # Uygulama başlığının girilmesi
  titlePanel("Merhabalar,"),
  # Kenar çubuğunun tanımlanması
  sidebarLayout(
    sidebarPanel(("Lütfen bilgilerinizi giriniz. "),
                 textInput(inputId = "yazı", label = "Adınızı giriniz.", placeholder = "Adınız"),
                 dateInput(inputId = "tarih", label = "Doğum tarihinizi seçiniz.", 
                           min = "1975-01-01", max = "2019-12-31", value = "1975-01-01",
                           format="dd/mm/yyyy", language="tr", weekstart=1),
                 selectInput(inputId = "kutucuk", label = "Cinsiyetinizi seçiniz.",
                                    choices = c("Kadın", "Erkek", "Diğer"), selected = NULL),
                 sliderInput(inputId = "kaydırmaCubugu", 
                             label = "Boyunuzu seçiniz. (cm)",
                             min = 100, max = 250, value = 150)
                 
    ),
    # Ana panonun tanımlanması
    mainPanel(("Bilgileriniz şu şekilde: "),
              textOutput("text1"),
              textOutput("text2"),
              textOutput("text3"),
              textOutput("text4")
    )
  )
)
# Arka planda işlemleri uygulayan "server"ın tanımlanması
server <- function(input, output) {
  output$text1 <- renderText(paste("Selam ",as.character(input$yazı)))
  output$text2 <- renderText(paste("Doğum Tarihiniz: ",as.character(input$tarih)))
  output$text3 <- renderText(paste("Cinsiyetiniz: ",as.character(input$kutucuk)))
  output$text4 <- renderText(paste("Boyunuz: ",as.character(input$kaydırmaCubugu)))
}
# Uygulamanın çalıştırılması
shinyApp(ui = ui, server = server)