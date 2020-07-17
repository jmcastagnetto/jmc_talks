library(tidyverse)
library(lubridate)

today <- Sys.Date()


# ECDC --------------------------------------------------------------------

ecdc_csv <- "https://opendata.ecdc.europa.eu/covid19/casedistribution/csv"
ecdc <- read.csv(
  ecdc_csv,
  na.strings = "",
  fileEncoding = "UTF-8-BOM"
) %>%
  rename(
    country = countriesAndTerritories,
    iso2c = geoId,
    iso3c = countryterritoryCode,
    continent = continentExp,
    pop2019 = popData2019
  ) %>%
  mutate(
    dateRep = dmy(dateRep),
    country = factor(str_replace_all(country, "_", " ")),
    iso2c = factor(iso2c),
    iso3c = factor(iso3c),
    continent = factor(continent),
    pop2019 = as.numeric(pop2019)
  ) %>%
  arrange(
    dateRep,
    iso3c
  ) %>%
  group_by(country) %>%
  mutate(
    cases_acc = cumsum(cases),
    deaths_acc = cumsum(deaths)
  ) %>%
  ungroup()

day_100cases <- ecdc %>%
  group_by(country) %>%
  mutate(
    day_100cases = (cases_acc >= 100),
    prev_day = lag(day_100cases)
  ) %>%
  filter(day_100cases == TRUE & prev_day == FALSE) %>%
  dplyr::select(country, dateRep) %>%
  rename(
    date100cases = dateRep
  )

day_10deaths <- ecdc %>%
  group_by(country) %>%
  mutate(
    day_10deaths = (deaths_acc >= 10),
    prev_day = lag(day_10deaths)
  ) %>%
  filter(day_10deaths == TRUE & prev_day == FALSE) %>%
  dplyr::select(country, dateRep) %>%
  rename(
    date10deaths = dateRep
  )

ecdc <- ecdc %>%
  left_join(
    day_100cases,
    by = "country"
  ) %>%
  left_join(
    day_10deaths,
    by = "country"
  ) %>%
  mutate(
    days_since_100cases = if_else(
        date100cases >= dateRep,
        0,
        as.duration(date100cases %--% dateRep) / ddays(1)
      ),
    days_since_10deaths = if_else(
        date10deaths >= dateRep,
        0,
        as.duration(date10deaths %--% dateRep) / ddays(1)
      )
  )

saveRDS(
  ecdc,
  file = paste0("datos/", today, "_ecdc.rds")
)
