library(shiny)
# Kullanıcı arayüzünün tanımlanması
ui <- fluidPage(
  # Uygulama başlığının girilmesi
  titlePanel("İlk Uygulama"),
  # Kenar çubuğunun tanımlanması
  sidebarLayout(
    sidebarPanel(("İlk kenar çubuğu")
    ),
    # Ana panonun tanımlanması
    mainPanel(("İlk ana pano")
    )
  )
)
# Arka planda işlemleri uygulayan "server"ın tanımlanması
server <- function(input, output) {
}
# Uygulamanın çalıştırılması
shinyApp(ui = ui, server = server)
