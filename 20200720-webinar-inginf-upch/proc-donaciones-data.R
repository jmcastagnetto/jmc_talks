library(tidyverse)
library(lubridate)

donaciones <- read_csv(
  "datos/covid19-donaciones/pcm_donaciones.csv",
  locale = locale(encoding = "latin1"),
  col_types = cols(
    .default = col_character(),
    ANO_EJE = col_double(),
    MES_MOVIMTO = col_double(),
    CANT_ARTICULO = col_double(),
    PRECIO_UNIT = col_double(),
    VALOR_TOTAL = col_double(),
    FECHA_MOVIMTO = col_date(format = "%d-%b-%y"),
    FECHA_REG = col_date(format = "%d-%b-%y"),
    FECHA_CONFIRMA = col_date(format = "%d-%b-%y")
  )
) %>%
  janitor::clean_names() %>%
  mutate_if(
    is.character,
    as.factor
  ) %>%
  mutate(
    mes = month(fecha_movimto, label = TRUE,
                abbr = FALSE, locale = "es_PE.utf8")
  )

saveRDS(
  donaciones,
  file = "datos/covid19-donaciones/donaciones.rds"
)
