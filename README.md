# 🌐 Visualización Interactiva de Indicadores Económicos y Sociales Globales con R Shin

[Ver demo en línea 🚀](https://denisulloa.shinyapps.io/PROYECTO0306/)

Este proyecto presenta un dashboard interactivo desarrollado en **R Shiny** que permite la exploración visual de más de 20 indicadores clave del desarrollo global, abarcando temas como economía, educación, salud, demografía, medio ambiente y empleo. La información visualizada proviene de dos fuentes reconocidas internacionalmente: **Gapminder** y el **Banco Mundial**, específicamente su base de datos oficial **World Development Indicators (WDI)**.

Este desarrollo se enmarca en el curso de **Herramientas Informáticas** de la **Maestría en Economía con mención en Data Analytics** de la **Universidad Continental**, como parte de un proyecto académico aplicado a la visualización de datos para la toma de decisiones.

**Gapminder**, fundación sin fines de lucro creada por Hans Rosling, es ampliamente conocida por su enfoque educativo, el uso de animaciones interactivas y la capacidad de comunicar visualmente el desarrollo global con claridad. Sin embargo, Gapminder no siempre mantiene una actualización estrictamente alineada con los informes oficiales, ya que sus datos han sido preprocesados, interpolados o transformados para fines de visualización y comunicación.

Por esta razón, en este proyecto se optó por utilizar directamente la **API del Banco Mundial a través del paquete `WDI` en R**, que permite acceder a los datos originales, actualizados y reportados oficialmente por los gobiernos de cada país. Esta decisión garantiza:
- **Trazabilidad**: cada dato puede vincularse con su indicador y código oficial (ej. `NY.GDP.PCAP.CD` para PIB per cápita).
- **Actualización automática**: la API WDI se sincroniza con la última información disponible.
- **Rigor técnico y reproducibilidad**: los datos no han sido interpolados, estimados ni alterados.

No obstante, se mantuvo la **inspiración visual y estructural de Gapminder**, incorporando mapas animados por año, comparaciones entre países, gráficos de burbujas y un enfoque visual accesible. De esta manera, el dashboard combina la **solidez técnica del WDI** con la **claridad y el enfoque educativo de Gapminder**, ofreciendo una herramienta interactiva útil tanto para investigadores como para estudiantes, docentes, instituciones públicas y tomadores de decisiones.

- Datos del Banco Mundial (WDI): [https://data.worldbank.org/indicator](https://data.worldbank.org/indicator)
- Gapminder Tools: [https://tools.gapminder.org/](https://tools.gapminder.org/)
- Gapminder Dataset: [https://www.gapminder.org/data/](https://www.gapminder.org/data/)

## 🌐 Enlace al Proyecto en Producción

El dashboard puede ser accedido públicamente en:  
🔗 [https://denisulloa.shinyapps.io/PROYECTO0306/](https://denisulloa.shinyapps.io/PROYECTO0306/)

Desplegado con [ShinyApps.io](https://www.shinyapps.io/), permitiendo la visualización interactiva desde cualquier navegador sin necesidad de instalar R.


## 📸 Vista general

<p align="center">
  <img src="img/Portada.PNG" width="700" />
</p>

---

## 🎯 Objetivo del Proyecto

Construir una herramienta visual interactiva que facilite el análisis comparativo de países a través de indicadores oficiales del Banco Mundial, apoyando la toma de decisiones académicas, gubernamentales y empresariales.

---

## 🔎 Paneles del Dashboard

### 1. 🌍 **Mapa Mundial por Categorías**

Visualización geoespacial animada por año. Permite analizar:

- Economía (PIB, ingreso, inflación)
- Educación (escolaridad, alfabetización)
- Salud (esperanza de vida, mortalidad infantil)
- Demografía (población, natalidad, mortalidad)
- Trabajo y desarrollo (empleo, pobreza)
- Medio ambiente (bosques, gasto militar)


### 2. 📈**Análisis por País**

Permite filtrar por país y rango de años:

<p align="center">
  <img src="img/Analisis paises.PNG" width="700" />
</p>

- Series temporales de cada indicador
- Comparación de natalidad vs mortalidad
- Relación PIB vs Esperanza de vida
- Comparación Pobreza vs Mortalidad

### 3. ⚖️ **Comparación entre Países**

<p align="center">
  <img src="img/Comparar paises.PNG" width="700" />
</p>

- Compara dos países simultáneamente por indicador y año
- Selección por categoría temática

### 4. 🌎 **Indicadores por Región**

<p align="center">
  <img src="img/Indicadores region.PNG" width="700" />
</p>

- Gráficos de burbujas por continente
- Tamaño proporcional a la población
- Relación entre variables como educación vs PIB, salud vs vida, etc.

### 5. 📥 **Explorador y Exportación de Datos**

<p align="center">
  <img src="img/Exportar.PNG" width="700" />
</p>

- Filtro por país e indicadores
- Exportación directa a CSV

---

## 📈 Variables e Indicadores

Este proyecto analiza datos de **2015 países** y forma parte del curso de **Herramientas Informáticas** de la **Maestría en Economía con mención en Data Analytics**. Se ha desarrollado con fines educativos y de análisis comparativo internacional, utilizando información oficial proveniente del **Banco Mundial (WDI)**.

Se incluyen **23 indicadores clave**, agrupados en las siguientes categorías:  
- **Economía (5 indicadores)**  
- **Educación (4 indicadores)**  
- **Salud (3 indicadores)**  
- **Demografía (5 indicadores)**  
- **Trabajo (3 indicadores)**  
- **Medio ambiente y seguridad (3 indicadores)**  

A continuación, se detallan los indicadores utilizados, junto con su definición, unidad de medida y período de información disponible:

| **Categoría**               | **Indicador**              | **Definición breve**                                                              | **Unidad**                        | **Años Disponibles** |
|----------------------------|----------------------------|-----------------------------------------------------------------------------------|-----------------------------------|----------------------|
| Economía                   | PIB per cápita             | Valor promedio del producto interno bruto por habitante                          | Dólares estadounidenses corrientes| 1982–2022           |
| Economía                   | Ingreso per cápita         | Ingreso nacional bruto dividido por la población total                           | Dólares estadounidenses corrientes| 1982–2022           |
| Economía                   | PIB total                  | Valor total del producto interno bruto                                           | Dólares estadounidenses corrientes| 1982–2022           |
| Economía                   | Ingreso nacional bruto     | Suma del valor agregado por residentes + ingresos netos del exterior             | Dólares estadounidenses corrientes| 1982–2022           |
| Economía                   | Inflación                  | Variación porcentual anual del índice de precios al consumidor                   | %                                 | 1982–2022           |
| Educación                  | Escolaridad                | Años promedio de educación formal recibidos por adultos                          | Años                              | 2010                |
| Educación                  | Gasto en educación         | Porcentaje del PIB destinado al gasto público en educación                       | % del PIB                         | 1982–2022           |
| Educación                  | Alfabetización             | Porcentaje de adultos que saben leer y escribir                                  | %                                 | 2014–2020           |
| Educación                  | Matrícula primaria         | Porcentaje de niños en edad escolar inscritos en primaria                        | %                                 | 1995–2018           |
| Salud                      | Gasto en salud             | Porcentaje del PIB destinado al gasto en salud                                   | % del PIB                         | 2000–2022           |
| Salud                      | Mortalidad infantil        | Muertes de menores de 1 año por cada 1,000 nacidos vivos                         | Por mil nacidos vivos             | 1982–2022           |
| Salud                      | Vacunación DPT             | Porcentaje de niños vacunados contra difteria, tos ferina y tétanos              | %                                 | 1982–2022           |
| Demografía                 | Esperanza de vida          | Años promedio que se espera que viva una persona al nacer                        | Años                              | 1982–2022           |
| Demografía                 | Población total            | Número total de habitantes                                                       | Habitantes                        | 1982–2022           |
| Demografía                 | Tasa de fertilidad         | Número promedio de hijos por mujer                                               | Hijos por mujer                   | 1982–2022           |
| Demografía                 | Tasa de natalidad          | Nacimientos por cada 1,000 personas                                              | Por mil personas                  | 1982–2022           |
| Demografía                 | Tasa de mortalidad         | Muertes por cada 1,000 personas                                                  | Por mil personas                  | 1982–2022           |
| Trabajo                    | Pobreza extrema            | Porcentaje de la población con ingresos menores a USD 2.15 diarios               | %                                 | 1997–2022           |
| Trabajo                    | Desempleo                  | Porcentaje de la fuerza laboral sin empleo                                       | %                                 | 1991–2022           |
| Trabajo                    | Empleo total               | Porcentaje de población activa empleada                                          | %                                 | 1991–2022           |
| Medio ambiente y seguridad| Superficie boscosa         | Porcentaje del territorio nacional cubierto por bosques                          | % del territorio nacional         | 1990–2022           |
| Medio ambiente y seguridad| Gasto militar              | Gasto gubernamental en defensa                                                   | % del PIB                         | 1982–2022           |

---

## 🧹 Limpieza y Procesamiento de Datos

- Se usó el paquete `WDI` para extraer datos directamente desde la API del Banco Mundial.
- Se filtraron años nulos y países sin código ISO3.
- Se asignaron continentes con `countrycode`.
- Se renombran columnas con nombres legibles para el usuario.
- La base de datos se mantiene actualizable y reproducible.

---

## 📚 Tecnología Usada

- **Lenguaje:** R 4.2+
- **Paquetes clave:** `shiny`, `plotly`, `WDI`, `shinydashboard`, `DT`, `dplyr`, `tidyr`, `countrycode`
- **Base de datos:** Banco Mundial - World Development Indicators (API oficial)

---

## ✅ Bondades del Proyecto

- 🔄 Conexión automática con la base del Banco Mundial actualizada.
- 📊 Exploración comparativa, por país, por región y multivariable.
- 📤 Exportación de datos filtrados para su uso académico o gubernamental.
- 💻 Código reproducible y escalable.
- 🧠 Ideal para docencia, investigación y análisis de políticas públicas.

## ⚠️ Limitaciones

- Algunos indicadores presentan series discontinuas.
- No todos los países tienen datos disponibles para todos los años.
- No se han realizado imputaciones ni predicciones.

---


## 👥 Colaboradores

- **SARAYA VILLAR, Miguel Saraya**  
  [🔗 github.com/MiguelSaraya](https://github.com/MiguelSaraya)
  
- **ULLOA DE LA CRUZ, Denis Yanin**  
  [🔗 github.com/DeniseUlloa](https://github.com/DeniseUlloa)

- **VILCA SANGAY, Jesús Omar**  
  [🔗 github.com/vilcas](https://github.com/vilcas)

- **YAULI MINA, Juan Admeht**  
  [🔗 github.com/ADMEHT](https://github.com/ADMEHT)
 

---

## 📝 Licencia

MIT License

## 📁 Repositorio del Proyecto

🔗 [https://github.com/DeniseUlloa/dashboard-wdi-indicadores-globales](https://github.com/DeniseUlloa/dashboard-wdi-indicadores-globales)

---

## 📚 Referencias Bibliográficas

- Banco Mundial. (2023). *World Development Indicators (WDI)*. Retrieved from [https://data.worldbank.org/indicator](https://data.worldbank.org/indicator)

- Gapminder Foundation. (2023). *Gapminder Tools & Data*. Retrieved from [https://www.gapminder.org/data/](https://www.gapminder.org/data/)

- Wickham, H., & Grolemund, G. (2017). *R for Data Science: Import, Tidy, Transform, Visualize, and Model Data*. O’Reilly Media. [https://r4ds.had.co.nz](https://r4ds.had.co.nz)

- Chang, W. (2021). *Shiny: Web Application Framework for R*. R package version 1.7.1. [https://shiny.rstudio.com](https://shiny.rstudio.com)

- Sievert, C. (2020). *Interactive Web-Based Data Visualization with R, plotly, and shiny*. Chapman and Hall/CRC. [https://plotly-r.com](https://plotly-r.com)

- R Core Team. (2023). *R: A Language and Environment for Statistical Computing*. R Foundation for Statistical Computing. [https://www.R-project.org/](https://www.R-project.org/)
