library(tidyverse)
library(lubridate)
library(archive)

ejec2020_raw <- read_csv(
  archive_read(
    archive = "datos/covid19-ejecucion-presupuestal/pcm_covid_2020.zip",
    file = 1
  ),
  col_types = cols(.default = col_character())
) %>%
  janitor::clean_names()

ejec2021_raw <- read_csv(
  archive_read(
    archive = "datos/covid19-ejecucion-presupuestal/pcm_covid_2021.zip",
    file = 1
  ),
  col_types = cols(.default = col_character())
) %>%
  janitor::clean_names()

ejec_presup <- bind_rows(ejec2020_raw, ejec2021_raw) %>%
  mutate_at(
    vars(ano_eje, mes_eje, monto_pia, monto_pim,
         monto_certificado, monto_comprometido_anual,
         monto_comprometido, monto_devengado,
         monto_girado),
    as.numeric
  ) %>%
  mutate_if(
    is.character,
    as.factor
  ) %>%
  mutate(
    tmp_mes = if_else(mes_eje == 0, 1, mes_eje),
    mes = month(tmp_mes, label = TRUE, abbr = TRUE,
                locale = "es_PE.utf8")
  ) %>%
  select(-tmp_mes) %>%
  rename(año_eje = ano_eje)

saveRDS(
  ejec_presup,
  file = "datos/covid19-ejecucion-presupuestal/ejec-presup.rds"
)


