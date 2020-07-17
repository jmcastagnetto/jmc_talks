library(tidyverse)
library(readxl)
library(lubridate)

dist_epp <- read_excel("datos/covid19-dist-epp/ADQUISISIONES.xls") %>%
  janitor::clean_names() %>%
  mutate(
    fecha = dmy(fecha),
    ruc = factor(ruc),
    proveedor = factor(proveedor),
    tipo = case_when(
      str_detect(producto, "(BATA|MAMELUCO|MANDIL|ROPA DESCARTABLE|CHAQUETA|PANTALÓN|TRAJE ENCAPSULADO)") ~ "ROPA",
      str_detect(producto, "BOTA") ~ "CALZADO",
      str_detect(producto, "CARETA") ~ "CARETA",
      str_detect(producto, "(GAFA|LENTE|PROTECTOR OCULAR)") ~ "PROTECCIÓN OCULAR",
      str_detect(producto, "(ALCOHOL|ALGODÓN|GEL|DESINFECTANTE)") ~ "DESINFECTANTE",
      str_detect(producto, "(GORRO|CAPUCHA)") ~ "PROTECCIÓN DE CABEZA",
      str_detect(producto, "GUANTE") ~ "PROTECCIÓN DE MANO",
      str_detect(producto, "(MASCAR|RESPIRADOR)") ~ "MASCARILLA/RESPIRADOR",
      str_detect(producto, "PAPEL") ~ "PAPEL",
      str_detect(producto, "(JABON|DETERGENTE)") ~ "LIMPIEZA",
      str_detect(producto, "(AZITRO|ENOXOPARINA|HIDROXICLOR|ETILPREDNISOLONA|CLORHEXIDINA|ENOXAPARINA|IVERMECTINA)") ~ "MEDICAMENTO",
      TRUE ~ "OTRO"
    )
  )

saveRDS(
  dist_epp,
  file = "datos/covid19-dist-epp/dist-epp.rds"
)
