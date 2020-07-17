library(tidyverse)
library(lubridate)

ejec_raw <- read_csv(
  "datos/covid19-ejecucion-presupuestal/pcm_covid.csv.gz",
  col_types = cols(.default = col_character())
) %>%
  janitor::clean_names()

ejec_presup <- ejec_raw %>%
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
    mes = month(tmp_mes, label = TRUE, abbr = FALSE,
                locale = "es_PE.utf8")
  ) %>%
  select(-tmp_mes)

saveRDS(
  ejec_presup,
  file = "datos/covid19-ejecucion-presupuestal/ejec-presup.rds"
)


