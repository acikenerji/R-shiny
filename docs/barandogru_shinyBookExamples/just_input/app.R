library(shiny)
# Kullanıcı arayüzünün tanımlanması
ui <- fluidPage(
  # Uygulama başlığının girilmesi
  titlePanel("İlk Uygulama"),
  # Kenar çubuğunun tanımlanması
  sidebarLayout(
    sidebarPanel(("İlk Yan Panel"),
                 checkboxGroupInput(inputId = "kutucuk", label = "İstediğiniz kutucuğu şeçiniz.",
                                    choices = c("Seçenek1", "Seçenek2")),
                 dateInput(inputId = "tarih", label = "İstediğiniz tarihi seçiniz.", 
                           min = "2019-01-01", max = "2019-12-31", value = "2019-01-01",
                           format="dd/mm/yyyy", language="tr", weekstart=1),
                 selectInput(inputId = "menü", label = "İstediğiniz seçimi yapınız.", 
                             choices = c("Seçenek1", "Seçenek2")),
                 sliderInput(inputId = "kaydırmaCubugu", 
                             label = "Aşağıdaki çubuğu kullanarak seçiminizi yapınız.",
                             min = 0, max = 30, value = 15),
                 textInput(inputId = "yazı", label = "Metin giriniz.", placeholder = "Buraya Metin")
    ),
    # Ana panonun tanımlanması
    mainPanel(("İlk Ana Panel")
    )
  )
)
# Arka planda işlemleri uygulayan "server"ın tanımlanması
server <- function(input, output) {
}
# Uygulamanın çalıştırılması
shinyApp(ui = ui, server = server)