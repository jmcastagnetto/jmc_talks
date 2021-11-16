library(tidyverse)
library(lubridate)

today <- Sys.Date()

# OWID --------------------------------------------------------------------

owid_csv <- "https://github.com/owid/covid-19-data/raw/master/public/data/owid-covid-data.csv"
local_csv <- "datos/covid19-owid/owid-covid-data.csv"
if (!file.exists(local_csv)) {
  download.file(owid_csv, destfile = local_csv)
}

owid <- read_csv(
  local_csv
) %>%
  mutate_if(
    is.character,
    as.factor
  )

day_100cases <- owid %>%
  group_by(location) %>%
  mutate(
    day_100cases = (total_cases >= 100),
    prev_day = lag(day_100cases)
  ) %>%
  filter(day_100cases == TRUE & prev_day == FALSE) %>%
  dplyr::select(location, date) %>%
  rename(
    date100cases = date
  )

day_10deaths <- owid %>%
  group_by(location) %>%
  mutate(
    day_10deaths = (total_deaths >= 10),
    prev_day = lag(day_10deaths)
  ) %>%
  filter(day_10deaths == TRUE & prev_day == FALSE) %>%
  dplyr::select(location, date) %>%
  rename(
    date10deaths = date
  )

owid <- owid %>%
  left_join(
    day_100cases,
    by = "location"
  ) %>%
  left_join(
    day_10deaths,
    by = "location"
  ) %>%
  mutate(
    days_since_100cases = if_else(
        date100cases >= date,
        0,
        as.duration(date100cases %--% date) / ddays(1)
      ),
    days_since_10deaths = if_else(
        date10deaths >= date,
        0,
        as.duration(date10deaths %--% date) / ddays(1)
      )
  )


saveRDS(
  owid,
  file = paste0("datos/covid19-owid/", today, "_owid.rds")
)
