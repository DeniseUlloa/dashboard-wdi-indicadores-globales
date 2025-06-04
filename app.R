# -------------------- LIBRERÍAS --------------------
library(shiny) #para la interfaz y estructura web.
library(dplyr) #manipulación de datos.
library(WDI) #acceso a datos del Banco Mundial.
library(plotly) #gráficos interactivos.
library(countrycode) #asignar continentes a países.
library(shinydashboard)
library(DT) #mostrar tablas interactivas.
library(tidyr)
library(rlang)


# -------------------- DEFINIR INDICADORES --------------------
#Objetivo : Lista con todos los códigos de indicadores a descargar del Banco Mundial (ej. PIB, esperanza de vida, pobreza...).
# Indicadores a usar
indicadores <- c(
  "NY.GDP.PCAP.CD", "NY.GNP.PCAP.CD", "NY.GDP.MKTP.CD", "NY.GNP.MKTP.CD", "FP.CPI.TOTL.ZG",
  "BAR.SCHL.15UP", "SE.XPD.TOTL.GD.ZS", "SE.ADT.LITR.ZS", "SE.PRM.NENR",
  "SH.XPD.CHEX.GD.ZS", "SH.DYN.MORT", "SH.IMM.IDPT",
  "SP.DYN.LE00.IN", "SP.DYN.TFRT.IN", "SP.DYN.CBRT.IN", "SP.DYN.CDRT.IN", "SP.POP.TOTL",
  "SI.POV.DDAY", "SL.UEM.TOTL.ZS", "SL.EMP.TOTL.SP.ZS",
  "AG.LND.FRST.ZS", "MS.MIL.XPND.GD.ZS"
)

# Descargar datos desde WDI

# Descarga segura de datos WDI.
# Valida qué columnas no se descargan.
# Renombra columnas con nombres más legibles para facilitar el uso en gráficos.
# Asigna continentes a cada país.
# Filtra datos nulos por año o continente.


datos <- WDI(country = "all", indicator = indicadores, start = 1982, end = 2022)

# Verificar indicadores faltantes
indicadores_faltantes <- setdiff(indicadores, names(datos))
if (length(indicadores_faltantes) > 0) {
  warning(paste("⚠️ No se pudieron descargar los siguientes indicadores:", paste(indicadores_faltantes, collapse = ", ")))
}

# Renombrar solo columnas disponibles
datos <- datos %>%
  rename_with(~ "pib", .cols = "NY.GDP.PCAP.CD") %>%
  rename_with(~ "ingreso", .cols = "NY.GNP.PCAP.CD") %>%
  rename_with(~ "pib_total", .cols = "NY.GDP.MKTP.CD") %>%
  rename_with(~ "ingreso_nacional_bruto", .cols = "NY.GNP.MKTP.CD") %>%
  rename_with(~ "inflacion", .cols = "FP.CPI.TOTL.ZG") %>%
  rename_with(~ "escolaridad", .cols = "BAR.SCHL.15UP") %>%
  rename_with(~ "gasto_educacion", .cols = "SE.XPD.TOTL.GD.ZS") %>%
  rename_with(~ "alfabetizacion", .cols = "SE.ADT.LITR.ZS") %>%
  rename_with(~ "matricula_primaria", .cols = "SE.PRM.NENR") %>%
  rename_with(~ "gasto_salud", .cols = "SH.XPD.CHEX.GD.ZS") %>%
  rename_with(~ "mortalidad_infantil", .cols = "SH.DYN.MORT") %>%
  rename_with(~ "vacunacion_dpt", .cols = "SH.IMM.IDPT") %>%
  rename_with(~ "esperanza_vida", .cols = "SP.DYN.LE00.IN") %>%
  rename_with(~ "fertilidad", .cols = "SP.DYN.TFRT.IN") %>%
  rename_with(~ "natalidad", .cols = "SP.DYN.CBRT.IN") %>%
  rename_with(~ "mortalidad", .cols = "SP.DYN.CDRT.IN") %>%
  rename_with(~ "poblacion", .cols = "SP.POP.TOTL") %>%
  rename_with(~ "pobreza", .cols = "SI.POV.DDAY") %>%
  rename_with(~ "desempleo", .cols = "SL.UEM.TOTL.ZS") %>%
  rename_with(~ "empleo_total", .cols = "SL.EMP.TOTL.SP.ZS") %>%
  rename_with(~ "bosques", .cols = "AG.LND.FRST.ZS") %>%
  rename_with(~ "gasto_militar", .cols = "MS.MIL.XPND.GD.ZS")

# Agregar continente y limpiar años vacíos
datos$continente <- countrycode(datos$iso3c, origin = "iso3c", destination = "continent")
datos <- datos %>% filter(!is.na(year), !is.na(continente))

# -------------------- FUNCION DE LEYENDAS --------------------

## Devuelve el nombre descriptivo
nombre_legible <- function(indicador_input) {
  nombres <- list(
    pib = "PIB per cápita (USD)",
    ingreso = "Ingreso per cápita (USD)",
    pib_total = "PIB total (USD)",
    ingreso_nacional_bruto = "Ingreso nacional bruto (USD)",
    inflacion = "Inflación (%)",
    escolaridad = "Escolaridad (años)",
    gasto_educacion = "Gasto en educación (% PBI)",
    alfabetizacion = "Alfabetización (%)",
    matricula_primaria = "Matrícula primaria (%)",
    gasto_salud = "Gasto en salud (% PBI)",
    mortalidad_infantil = "Mortalidad infantil (por mil)",
    vacunacion_dpt = "Vacunación DPT (%)",
    esperanza_vida = "Esperanza de vida (años)",
    fertilidad = "Tasa de fertilidad",
    natalidad = "Natalidad (por mil)",
    mortalidad = "Mortalidad (por mil)",
    poblacion = "Población total",
    pobreza = "Pobreza extrema (%)",
    desempleo = "Desempleo (%)",
    empleo_total = "Empleo total (%)",
    bosques = "Superficie boscosa (%)",
    gasto_militar = "Gasto militar (% PBI)"
  )
  return(nombres[[indicador_input]])
}

### Devuelve el código del WDI
# Función para convertir nombre interno a código WDI
codigo_wdi <- function(nombre) {
  codigos <- list(
    pib = "NY.GDP.PCAP.CD",
    ingreso = "NY.GNP.PCAP.CD",
    pib_total = "NY.GDP.MKTP.CD",
    ingreso_nacional_bruto = "NY.GNP.MKTP.CD",
    inflacion = "FP.CPI.TOTL.ZG",
    escolaridad = "BAR.SCHL.15UP",
    gasto_educacion = "SE.XPD.TOTL.GD.ZS",
    alfabetizacion = "SE.ADT.LITR.ZS",
    matricula_primaria = "SE.PRM.NENR",
    gasto_salud = "SH.XPD.CHEX.GD.ZS",
    mortalidad_infantil = "SH.DYN.MORT",
    vacunacion_dpt = "SH.IMM.IDPT",
    esperanza_vida = "SP.DYN.LE00.IN",
    fertilidad = "SP.DYN.TFRT.IN",
    natalidad = "SP.DYN.CBRT.IN",
    mortalidad = "SP.DYN.CDRT.IN",
    poblacion = "SP.POP.TOTL",
    pobreza = "SI.POV.DDAY",
    desempleo = "SL.UEM.TOTL.ZS",
    empleo_total = "SL.EMP.TOTL.SP.ZS",
    bosques = "AG.LND.FRST.ZS",
    gasto_militar = "MS.MIL.XPND.GD.ZS"
  )
  return(codigos[[nombre]])
}




# -------------------- UI --------------------
tags$head(tags$style(HTML(".shiny-output-error { visibility: hidden; } .shiny-output-error:before { visibility: hidden; }")))

ui <- dashboardPage(
  dashboardHeader(title = "🌐 Dashboard Global de Indicadores"),
  #Mapa Mundial
  dashboardSidebar(
    sidebarMenu(
      menuItem("Mapa Mundial", tabName = "mapa", icon = icon("globe")),
      menuItem("Análisis por País", tabName = "pais", icon = icon("flag")),
      menuItem("Comparar Países", tabName = "comparar", icon = icon("balance-scale")),
      menuItem("Indicadores por Región", tabName = "region", icon = icon("map")),
      menuItem("Explorador de Datos", tabName = "tabla", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "mapa",
              fluidPage(
                h2("🌍 Mapas por Categoría", align = "center"),
                tabBox(width = 12, height = "auto",
                       
                       tabPanel("💰 Economía y Finanzas",
                                box(width = 12, solidHeader = TRUE, status = "primary",
                                    selectInput("indicador_economia_map", "Indicador:", choices = c(
                                      "PIB per cápita" = "pib",
                                      "Ingreso per cápita" = "ingreso",
                                      "PIB total" = "pib_total",
                                      "Ingreso nacional bruto" = "ingreso_nacional_bruto",
                                      "Inflación" = "inflacion"
                                    )),
                                    plotlyOutput("mapa_economia", height = "500px"),
                                    plotlyOutput("ranking_economia")
                                )
                       ),
                       
                       tabPanel("📚 Educación",
                                box(width = 12, solidHeader = TRUE, status = "info",
                                    selectInput("indicador_educacion_map", "Indicador:", choices = c(
                                      "Escolaridad" = "escolaridad",
                                      "Gasto en educación" = "gasto_educacion",
                                      "Alfabetización" = "alfabetizacion",
                                      "Matrícula primaria" = "matricula_primaria"
                                    )),
                                    plotlyOutput("mapa_educacion", height = "500px"),
                                    plotlyOutput("ranking_educacion")
                                )
                       ),
                       
                       tabPanel("🏥 Salud",
                                box(width = 12, solidHeader = TRUE, status = "warning",
                                    selectInput("indicador_salud_map", "Indicador:", choices = c(
                                      "Gasto en salud" = "gasto_salud",
                                      "Mortalidad infantil" = "mortalidad_infantil",
                                      "Vacunación DPT" = "vacunacion_dpt"
                                    )),
                                    plotlyOutput("mapa_salud", height = "500px"),
                                    plotlyOutput("ranking_salud")
                                )
                       ),
                       
                       tabPanel("👶 Demografía",
                                box(width = 12, solidHeader = TRUE, status = "success",
                                    selectInput("indicador_demo_map", "Indicador:", choices = c(
                                      "Esperanza de vida" = "esperanza_vida",
                                      "Fertilidad" = "fertilidad",
                                      "Natalidad" = "natalidad",
                                      "Mortalidad" = "mortalidad",
                                      "Población" = "poblacion"
                                    )),
                                    plotlyOutput("mapa_demo", height = "500px"),
                                    plotlyOutput("ranking_demo")
                                )
                       ),
                       
                       tabPanel("👥 Trabajo y Desarrollo",
                                box(width = 12, solidHeader = TRUE, status = "danger",
                                    selectInput("indicador_trabajo_map", "Indicador:", choices = c(
                                      "Pobreza" = "pobreza",
                                      "Desempleo" = "desempleo",
                                      "Empleo total" = "empleo_total"
                                    )),
                                    plotlyOutput("mapa_trabajo", height = "500px"),
                                    plotlyOutput("ranking_trabajo")
                                )
                       ),
                       
                       tabPanel("🌱 Medio Ambiente y Seguridad",
                                box(width = 12, solidHeader = TRUE, status = "success",
                                    selectInput("indicador_ambiente_map", "Indicador:", choices = c(
                                      "Superficie boscosa" = "bosques",
                                      "Gasto militar" = "gasto_militar"
                                    )),
                                    plotlyOutput("mapa_ambiente", height = "500px"),
                                    plotlyOutput("ranking_ambiente")
                                )
                       )
                )
              )
      ),
      
      
      #Analisis por pais
      tabItem(tabName = "pais",
              fluidRow(
                box(width = 3,
                    selectInput("pais_ind", "Selecciona país:", choices = unique(datos$country)),
                    sliderInput("rango_anios", "Selecciona el rango de años:",
                                min = min(datos$year, na.rm = TRUE),
                                max = max(datos$year, na.rm = TRUE),
                                value = c(2000, 2022),
                                step = 1,
                                sep = "")
                ),
                box(width = 9, title = "Indicadores por País Seleccionado", status = "primary", solidHeader = TRUE,
                    h4(textOutput("titulo_pais"))
                )
              ),
              
              ## FILA 1 - ECONOMÍA
              fluidRow(
                column(12,
                       h3("📊 Indicadores Económicos"),
                       p("Esta sección presenta la evolución del desempeño económico del país, incluyendo crecimiento del PIB, inflación y comparaciones clave.")
                )
              ),
              fluidRow(
                box(width = 4, title = "PIB per cápita (USD)", plotlyOutput("pib_pais")),
                box(width = 4, title = "Inflación (%)", plotlyOutput("inflacion_pais")),
                box(width = 4, title = "PIB Total (USD)", plotlyOutput("pib_total_pais"))
              ),
              
              ## FILA 2 - EDUCACIÓN
              fluidRow(
                column(12,
                       h3("🎓 Indicadores Educativos"),
                       p("Análisis de escolaridad promedio, tasa de alfabetización y gasto público en educación.")
                )
              ),
              fluidRow(
                box(width = 4, title = "Escolaridad promedio (años)", plotlyOutput("escolaridad_pais")),
                box(width = 4, title = "Alfabetización (%)", plotlyOutput("alfabetizacion_pais")),
                box(width = 4, title = "Gasto en Educación (% del PIB)", plotlyOutput("gasto_edu_pais"))
              ),
              
              ## FILA 3 - SALUD
              fluidRow(
                column(12,
                       h3("🏥 Indicadores de Salud"),
                       p("Observa la evolución en esperanza de vida, mortalidad infantil y gasto en salud.")
                )
              ),
              fluidRow(
                box(width = 4, title = "Esperanza de Vida (años)", plotlyOutput("esperanza_vida_pais")),
                box(width = 4, title = "Mortalidad Infantil (por mil nacidos vivos)", plotlyOutput("mortalidad_infantil_pais")),
                box(width = 4, title = "Gasto en Salud (% del PIB)", plotlyOutput("gasto_salud_pais"))
              ),
              
              ## FILA 4 - DEMOGRAFÍA
              fluidRow(
                column(12,
                       h3("👶 Indicadores Demográficos"),
                       p("Incluye la evolución de la población, tasas de natalidad y mortalidad.")
                )
              ),
              fluidRow(
                box(width = 4, title = "Población Total", plotlyOutput("poblacion_pais")),
                box(width = 4, title = "Natalidad vs Mortalidad (por mil)", plotlyOutput("natalidad_mortalidad_pais")),
                box(width = 4, title = "Mortalidad (por mil)", plotlyOutput("mortalidad_pais"))
              ),
              
              ## FILA 5 - TRABAJO Y DESARROLLO
              fluidRow(
                column(12,
                       h3("👷 Trabajo y Desarrollo Social"),
                       p("Muestra los niveles de empleo, desempleo y pobreza en el país seleccionado.")
                )
              ),
              fluidRow(
                box(width = 4, title = "Desempleo (%)", plotlyOutput("desempleo_pais")),
                box(width = 4, title = "Pobreza Extrema (%)", plotlyOutput("pobreza_pais")),
                box(width = 4, title = "Empleo Total (%)", plotlyOutput("empleo_total_pais"))
              ),
              
              ## FILA 6 - CORRELACIONES
              fluidRow(
                column(12,
                       h3("🔁 Correlaciones entre Indicadores"),
                       p("Explora las relaciones entre indicadores clave como PIB, esperanza de vida y pobreza.")
                )
              ),
              fluidRow(
                box(width = 4, title = "PIB per cápita vs Esperanza de Vida", plotlyOutput("pib_vs_vida")),
                box(width = 4, title = "Pobreza extrema vs Mortalidad", plotlyOutput("pobreza_vs_mortalidad")),
                box(width = 4, title = "Esperanza de Vida vs PIB per cápita", plotlyOutput("vida_vs_pib"))
              )
              
      ),
      #Comparar Paises
      tabItem(tabName = "comparar",
              fluidPage(
                fluidRow(
                  column(6,
                         selectInput("pais1", "País 1:", choices = NULL),
                         selectInput("pais2", "País 2:", choices = NULL),
                         sliderInput("rango_anios", "Rango de años:",
                                     min = 1982, max = 2022, value = c(2000, 2020), step = 1)
                  )
                ),
                hr(),
                
                # Fila 1: Economía - Educación - Salud
                fluidRow(
                  column(4,
                         selectInput("indicador_economia", "Economía y Finanzas", choices = c(
                           "PIB per cápita" = "NY.GDP.PCAP.CD",
                           "PNB per cápita" = "NY.GNP.PCAP.CD",
                           "PIB total" = "NY.GDP.MKTP.CD",
                           "PNB total" = "NY.GNP.MKTP.CD",
                           "Inflación" = "FP.CPI.TOTL.ZG"
                         )),
                         plotlyOutput("grafico_economia")
                  ),
                  column(4,
                         selectInput("indicador_educacion", "Educación", choices = c(
                           "Escolaridad promedio (15+)" = "BAR.SCHL.15UP",
                           "Gasto educación (%PIB)" = "SE.XPD.TOTL.GD.ZS",
                           "Alfabetización adultos" = "SE.ADT.LITR.ZS",
                           "Matrícula primaria neta" = "SE.PRM.NENR"
                         )),
                         plotlyOutput("grafico_educacion")
                  ),
                  column(4,
                         selectInput("indicador_salud", "Salud", choices = c(
                           "Gasto salud (%PIB)" = "SH.XPD.CHEX.GD.ZS",
                           "Mortalidad infantil" = "SH.DYN.MORT",
                           "Vacunación DPT" = "SH.IMM.IDPT"
                         )),
                         plotlyOutput("grafico_salud")
                  )
                ),
                
                # Fila 2: Demografía - Trabajo - Medio Ambiente
                fluidRow(
                  column(4,
                         selectInput("indicador_demografia", "Demografía", choices = c(
                           "Esperanza de vida" = "SP.DYN.LE00.IN",
                           "Tasa de fertilidad" = "SP.DYN.TFRT.IN",
                           "Tasa de natalidad" = "SP.DYN.CBRT.IN",
                           "Tasa de mortalidad" = "SP.DYN.CDRT.IN",
                           "Población total" = "SP.POP.TOTL"
                         )),
                         plotlyOutput("grafico_demografia")
                  ),
                  column(4,
                         selectInput("indicador_trabajo", "Trabajo y Desarrollo Social", choices = c(
                           "Pobreza (<1.90 USD/día)" = "SI.POV.DDAY",
                           "Desempleo (%)" = "SL.UEM.TOTL.ZS",
                           "Empleo total (%)" = "SL.EMP.TOTL.SP.ZS"
                         )),
                         plotlyOutput("grafico_trabajo")
                  ),
                  column(4,
                         selectInput("indicador_ambiente", "Medio Ambiente y Seguridad", choices = c(
                           "Superficie boscosa (%)" = "AG.LND.FRST.ZS",
                           "Gasto militar (%PIB)" = "MS.MIL.XPND.GD.ZS"
                         )),
                         plotlyOutput("grafico_ambiente")
                  )
                )
              )
      ),
      #Indicadores por region
      tabItem(tabName = "region",
              fluidPage(
                h2("📊 Indicadores Regionales", align = "center"),
                
                selectInput("continentSelect", "Selecciona continente:",
                            choices = c("Todos", unique(datos$continente)),
                            selected = "Todos"),
                hr(),
                
                fluidRow(
                  column(6, plotlyOutput("burbuja1")),
                  column(6, plotlyOutput("burbuja2"))
                ),
                fluidRow(
                  column(6, plotlyOutput("burbuja3")),
                  column(6, plotlyOutput("burbuja4"))
                ),
                fluidRow(
                  column(6, plotlyOutput("burbuja5")),
                  column(6, plotlyOutput("burbuja6"))
                )
              )
      ),
      #Explorador de datos 
      tabItem(tabName = "tabla",
              fluidPage(
                h3("🌍 Explorador de Datos por Continente e Indicadores", align = "center"),
                fluidRow(
                  column(4,
                         selectInput("filtro_pais", "Selecciona país:",
                                     choices = c("Todos", sort(unique(datos$country))),
                                     selected = "Todos")
                  ),
                  column(8,
                         selectizeInput("filtro_indicadores", "Selecciona indicadores a mostrar:",
                                        choices = setdiff(names(datos)[5:ncol(datos)], "continente"),
                                        selected = c("pib", "esperanza_vida", "poblacion"),
                                        multiple = TRUE)
                  )
                ),
                br(),
                DT::dataTableOutput("tabla_datos"),
                br(),
                downloadButton("descargar_datos", "Descargar CSV Filtrado")
              )
      )
      
      
      
      
      
      
      
      
    )
  )
)


# -------------------- SERVER --------------------

library(WDI)


# Función para convertir nombre de variable a etiqueta
nombre_legible <- function(nombre) {
  lista <- list(
    "NY.GDP.PCAP.CD" = "PIB per cápita (USD)",
    "NY.GNP.PCAP.CD" = "PNB per cápita (USD)",
    "NY.GDP.MKTP.CD" = "PIB total (USD)",
    "NY.GNP.MKTP.CD" = "PNB total (USD)",
    "FP.CPI.TOTL.ZG" = "Inflación (%)",
    "BAR.SCHL.15UP" = "Escolaridad promedio (15+)",
    "SE.XPD.TOTL.GD.ZS" = "Gasto en educación (% PBI)",
    "SE.ADT.LITR.ZS" = "Alfabetización adultos (%)",
    "SE.PRM.NENR" = "Matrícula primaria neta (%)",
    "SH.XPD.CHEX.GD.ZS" = "Gasto salud (% PBI)",
    "SH.DYN.MORT" = "Mortalidad infantil (por mil)",
    "SH.IMM.IDPT" = "Vacunación DPT (%)",
    "SP.DYN.LE00.IN" = "Esperanza de vida (años)",
    "SP.DYN.TFRT.IN" = "Tasa de fertilidad",
    "SP.DYN.CBRT.IN" = "Tasa de natalidad",
    "SP.DYN.CDRT.IN" = "Tasa de mortalidad",
    "SP.POP.TOTL" = "Población total",
    "SI.POV.DDAY" = "Pobreza (<1.90 USD/día)",
    "SL.UEM.TOTL.ZS" = "Desempleo (%)",
    "SL.EMP.TOTL.SP.ZS" = "Empleo total (%)",
    "AG.LND.FRST.ZS" = "Superficie boscosa (%)",
    "MS.MIL.XPND.GD.ZS" = "Gasto militar (% PBI)"
  )
  return(lista[[nombre]] %||% nombre)
}




# Lista limpia de países (sin agregados regionales)
lista_paises <- WDI_data$country %>%
  dplyr::filter(region != "Aggregates") %>%
  dplyr::pull(country)


server <- function(input, output, session) {
  render_mapa <- function(indicador_input, color_mapa = "Blues") {
    req(indicador_input)
    
    # Validación: si no está en datos, salir sin error visual
    if (!(indicador_input %in% names(datos))) {
      return(plotly_empty() %>%
               layout(title = list(text = " ", font = list(size = 1))))
    }
    
    df <- datos %>%
      filter(!is.na(.data[[indicador_input]]), !is.na(iso3c), !is.na(year))
    
    # Si no hay datos, no graficar
    if (nrow(df) == 0) {
      return(plotly_empty() %>%
               layout(title = list(text = "No hay datos disponibles para este indicador", font = list(size = 14))))
    }
    
    plot_geo(df) %>%
      add_trace(
        z = ~.data[[indicador_input]],
        color = ~.data[[indicador_input]],
        colors = color_mapa,
        text = ~paste(country, "<br>", round(.data[[indicador_input]], 2)),
        locations = ~iso3c,
        locationmode = "ISO-3",
        frame = ~year,
        colorbar = list(title = nombre_legible(indicador_input))
      ) %>%
      layout(
        title = list(
          text = paste("📈 Evolución del indicador:", nombre_legible(indicador_input)),
          font = list(size = 18)
        ),
        geo = list(showframe = FALSE, showcoastlines = FALSE)
      )
  }
  
  ranking_top5 <- function(indicador_input, output_id) {
    output[[output_id]] <- renderPlotly({
      req(indicador_input)
      df <- datos %>%
        filter(year == 2022, !is.na(.data[[indicador_input]])) %>%
        arrange(desc(.data[[indicador_input]])) %>%
        slice_head(n = 5)
      
      plot_ly(df,
              x = ~reorder(country, .data[[indicador_input]]),
              y = ~.data[[indicador_input]],
              type = "bar",
              marker = list(color = 'steelblue')) %>%
        layout(
          title = paste("🏆 Top 5 países en", nombre_legible(indicador_input), "en 2022"),
          xaxis = list(title = ""),
          yaxis = list(title = nombre_legible(indicador_input))
        )
    })
  }
  
  
  output$mapa_economia <- renderPlotly({ render_mapa(input$indicador_economia_map, "Blues") })
  observeEvent(input$indicador_economia_map, { ranking_top5(input$indicador_economia_map, "ranking_economia") })
  
  output$mapa_educacion <- renderPlotly({ render_mapa(input$indicador_educacion_map, "PuBuGn") })
  observeEvent(input$indicador_educacion_map, { ranking_top5(input$indicador_educacion_map, "ranking_educacion") })
  
  output$mapa_salud <- renderPlotly({ render_mapa(input$indicador_salud_map, "Greens") })
  observeEvent(input$indicador_salud_map, { ranking_top5(input$indicador_salud_map, "ranking_salud") })
  
  output$mapa_demo <- renderPlotly({ render_mapa(input$indicador_demo_map, "Oranges") })
  observeEvent(input$indicador_demo_map, { ranking_top5(input$indicador_demo_map, "ranking_demo") })
  
  output$mapa_trabajo <- renderPlotly({ render_mapa(input$indicador_trabajo_map, "Reds") })
  observeEvent(input$indicador_trabajo_map, { ranking_top5(input$indicador_trabajo_map, "ranking_trabajo") })
  
  output$mapa_ambiente <- renderPlotly({ render_mapa(input$indicador_ambiente_map, "YlGnBu") })
  observeEvent(input$indicador_ambiente_map, { ranking_top5(input$indicador_ambiente_map, "ranking_ambiente") })
  
  
  output$serie_pais <- renderPlotly({
    req(input$pais_ind, input$indicadores_pais)
    df <- datos %>% filter(country == input$pais_ind, year >= input$anio_pais[1], year <= input$anio_pais[2])
    p <- plot_ly(df, x = ~year)
    for (ind in input$indicadores_pais) {
      p <- add_lines(p, y = ~get(ind), name = ind)
    }
    p
  })
  
  
  #Análisis por país	Serie de indicadores por país con gráficos
  output$titulo_pais <- renderText({
    paste("Visualización para:", input$pais_ind)
  })
  
  # ECONOMÍA
  output$pib_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~pib, type = 'scatter', mode = 'lines+markers', name = "PIB per cápita")
  })
  
  output$inflacion_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~inflacion, type = 'scatter', mode = 'lines+markers', name = "Inflación")
  })
  
  output$pib_total_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~pib_total, type = "scatter", mode = "lines+markers", name = "PIB Total (USD)")
  })
  
  # EDUCACIÓN
  output$escolaridad_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~escolaridad, type = 'scatter', mode = 'lines+markers')
  })
  
  output$alfabetizacion_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~alfabetizacion, type = 'scatter', mode = 'lines+markers')
  })
  
  output$gasto_edu_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~gasto_educacion, type = 'scatter', mode = 'lines+markers')
  })
  
  # SALUD
  output$esperanza_vida_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~esperanza_vida, type = 'scatter', mode = 'lines+markers')
  })
  
  output$mortalidad_infantil_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~mortalidad_infantil, type = 'scatter', mode = 'lines+markers')
  })
  
  output$gasto_salud_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~gasto_salud, type = 'scatter', mode = 'lines+markers')
  })
  
  # DEMOGRAFÍA
  output$poblacion_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~poblacion, type = 'scatter', mode = 'lines+markers')
  })
  
  output$natalidad_mortalidad_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df) %>%
      add_trace(x = ~year, y = ~natalidad, name = "Natalidad", type = "scatter", mode = "lines") %>%
      add_trace(x = ~year, y = ~mortalidad, name = "Mortalidad", type = "scatter", mode = "lines")
  })
  
  output$mortalidad_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~mortalidad, type = 'scatter', mode = 'lines+markers')
  })
  
  # TRABAJO Y DESARROLLO
  output$desempleo_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~desempleo, type = 'scatter', mode = 'lines+markers')
  })
  
  output$pobreza_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~pobreza, type = 'scatter', mode = 'lines+markers')
  })
  
  output$empleo_total_pais <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~year, y = ~empleo_total, type = 'scatter', mode = 'lines+markers')
  })
  
  # CORRELACIONES
  output$pib_vs_vida <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~pib, y = ~esperanza_vida, type = "scatter", mode = "markers", text = ~year)
  })
  
  output$pobreza_vs_mortalidad <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~pobreza, y = ~mortalidad, type = "scatter", mode = "markers", text = ~year)
  })
  
  output$vida_vs_pib <- renderPlotly({
    df <- datos %>% filter(country == input$pais_ind, year >= input$rango_anios[1], year <= input$rango_anios[2])
    plot_ly(df, x = ~esperanza_vida, y = ~pib, type = "scatter", mode = "markers", text = ~year)
  })
  
  
  
  
  
  # Comparar Países	Comparación de 2 países por área temática
  renderizar_grafico <- function(input_id, output_id) {
    output[[output_id]] <- renderPlotly({
      req(input[[input_id]], input$pais1, input$pais2)
      
      paises_codigos <- countrycode(c(input$pais1, input$pais2), origin = "country.name", destination = "iso2c")
      if (any(is.na(paises_codigos))) {
        showNotification("⚠️ País no válido. Usa nombres estándar reconocidos por el Banco Mundial.", type = "error")
        return(NULL)
      }
      
      df <- WDI(country = paises_codigos,
                indicator = input[[input_id]],
                start = input$rango_anios[1],
                end = input$rango_anios[2])
      
      if (is.null(df) || nrow(df) == 0) {
        return(plotly_empty() %>%
                 layout(title = paste("⚠️ No hay datos disponibles para el indicador:", nombre_legible(input[[input_id]]))))
      }
      
      df <- df %>% rename(valor = 5)
      
      nombre_indicador <- nombre_legible(input[[input_id]]) %||% input[[input_id]]
      
      plot_ly(df, x = ~year, y = ~valor, color = ~country, type = "scatter", mode = "lines+markers") %>%
        layout(title = paste("📈 Comparación de", nombre_indicador, "entre", input$pais1, "y", input$pais2),
               xaxis = list(title = "Año"),
               yaxis = list(title = "Valor"))
    })
  }
  
  # Llamar para cada gráfico
  renderizar_grafico("indicador_economia", "grafico_economia")
  renderizar_grafico("indicador_educacion", "grafico_educacion")
  renderizar_grafico("indicador_salud", "grafico_salud")
  renderizar_grafico("indicador_demografia", "grafico_demografia")
  renderizar_grafico("indicador_trabajo", "grafico_trabajo")
  renderizar_grafico("indicador_ambiente", "grafico_ambiente")
  
  # ACTUALIZAR LOS SELECTINPUT DE PAÍS 1 Y PAÍS 2
  observe({
    paises_disponibles <- sort(unique(datos$country))
    updateSelectInput(session, "pais1", choices = paises_disponibles, selected = "Peru")
    updateSelectInput(session, "pais2", choices = paises_disponibles, selected = "Chile")
  })
  
  
  # Por región	Burbujas comparativas por continente e indicadores clave
  # Función genérica para renderizar burbujas
  render_burbuja <- function(var_x, var_y, var_size, color, output_id) {
    output[[output_id]] <- renderPlotly({
      data <- datos
      if (input$continentSelect != "Todos") {
        data <- data %>% filter(continente == input$continentSelect)
      }
      
      plot_ly(data,
              x = ~get(var_x),
              y = ~get(var_y),
              size = ~get(var_size),
              color = ~get(color),
              text = ~paste("País:", country, "<br>Año:", year),
              frame = ~year,
              type = 'scatter',
              mode = 'markers',
              sizes = c(10, 60),
              marker = list(opacity = 0.7, sizemode = 'diameter', line = list(width = 0.5, color = '#999'))) %>%
        layout(title = paste0(nombre_legible(var_y), " vs ", nombre_legible(var_x)),
               xaxis = list(title = nombre_legible(var_x)),
               yaxis = list(title = nombre_legible(var_y)))
    })
  }
  
  # Renderiza los 6 gráficos con base en las relaciones definidas
  observe({
    render_burbuja("pib", "esperanza_vida", "poblacion", "continente", "burbuja1")
    render_burbuja("pib", "mortalidad_infantil", "poblacion", "continente", "burbuja2")
    render_burbuja("escolaridad", "pib", "poblacion", "continente", "burbuja3")
    render_burbuja("alfabetizacion", "mortalidad_infantil", "poblacion", "continente", "burbuja4")
    render_burbuja("empleo_total", "pobreza", "poblacion", "continente", "burbuja5")
    render_burbuja("gasto_salud", "esperanza_vida", "poblacion", "continente", "burbuja6")
  })
  
  
  
  #Tabla de datos	Conjunto de datos completo con opción para descargar en CSV
  # Tabla filtrada por país e indicadores
  output$tabla_datos <- DT::renderDataTable({
    data <- datos
    
    # Filtrar por país si se selecciona uno
    if (input$filtro_pais != "Todos") {
      data <- data %>% filter(country == input$filtro_pais)
    }
    
    columnas_a_mostrar <- c("country", "iso2c", "iso3c", "year", input$filtro_indicadores)
    data %>% select(all_of(columnas_a_mostrar)) %>%
      datatable(options = list(pageLength = 10, scrollX = TRUE))
  })
  
  # Descarga por país filtrado
  output$descargar_datos <- downloadHandler(
    filename = function() {
      paste0("datos_", ifelse(input$filtro_pais == "Todos", "global", input$filtro_pais), "_", Sys.Date(), ".csv")
    },
    content = function(file) {
      data <- datos
      if (input$filtro_pais != "Todos") {
        data <- data %>% filter(country == input$filtro_pais)
      }
      columnas_a_mostrar <- c("country", "iso2c", "iso3c", "year", input$filtro_indicadores)
      write.csv(data[, columnas_a_mostrar, drop = FALSE], file, row.names = FALSE)
    }
  )
}




# -------------------- INICIAR APP --------------------
shinyApp(ui = ui, server = server)
