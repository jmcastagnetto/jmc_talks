library(tidyverse)
library(lubridate)

meses <- c("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
           "Agosto","Septiembre","Octubre","Noviembre","Diciembre")

donaciones <- read_csv(
  "datos/covid19-donaciones/pcm_donaciones.csv",
  locale = locale(encoding = "latin1")
) %>%
  janitor::clean_names() %>%
  mutate_if(
    is.character,
    as.factor
  ) %>%
  mutate(
    nombre_mes = str_to_sentence(nombre_mes) %>%
      factor(levels = meses, ordered = TRUE)
  ) %>%
  group_by(region, ano_eje, nombre_mes) %>%
  summarise(
    monto = sum(valor_total, na.rm = TRUE)
  ) %>%
  mutate(
    monto_acum = cumsum(monto)
  ) %>%
  ungroup()

saveRDS(
  donaciones,
  file = "datos/covid19-donaciones/donaciones.rds"
)



