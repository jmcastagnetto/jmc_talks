library(dplyr)

load(
  here::here("openflights-org-20190920.Rdata")
)

pe_airports <- airports %>%
  filter(country == "Peru") %>%
  left_join(
    countries,
    by = c("country" = "name")
  )

pe_flights <- routes %>%
  filter(
    of_source_id %in% pe_airports$airport_id |
      of_dest_id %in% pe_airports$airport_id
  ) %>%
  left_join(
    airlines,
    by = c("of_airline_id" = "airline_id")
  ) %>%
  rename(
    airline_name = name
  ) %>%
  left_join(
    airports %>% select(airport_id, name, lat, lon),
    by = c("of_source_id" = "airport_id")
  ) %>%
  rename(
    source_lat = lat,
    source_lon = lon,
    source_name = name
  ) %>%
  left_join(
    airports %>% select(airport_id, name, lat, lon),
    by = c("of_dest_id" = "airport_id")
  ) %>%
  rename(
    dest_lat = lat,
    dest_lon = lon,
    dest_name = name
  ) %>%
  filter(
    !is.na(source_lat) &
      !is.na(source_lon) &
      !is.na(dest_lat) &
      !is.na(dest_lon)
  )

save(
  pe_flights,
  file = here::here("peru-flights.Rdata")
)
