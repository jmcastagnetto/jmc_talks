library(readr)

airports <- read_csv(
  file = here::here("airports.dat"),
  trim_ws = TRUE,
  col_names = c("airport_id",
                "name",
                "city",
                "country",
                "iata",
                "icao",
                "lat",
                "lon",
                "altitude",
                "tz",
                "dst",
                "tzstr",
                "type",
                "source"),
  col_types = "ccccccnnnncccc",
  na = c("", "\\N", "N/A", "-")
)

airlines <- read_csv(
  file = here::here("airlines.dat"),
  trim_ws = TRUE,
  col_names = c("airline_id",
                "name",
                "alias",
                "iata",
                "icao",
                "callsign",
                "country",
                "active"),
  col_types = strrep("c", 8),
  na = c("", "\\N", "N/A", "-")
)

routes <- read_csv(
  file = here::here("routes.dat"),
  trim_ws = TRUE,
  na = c("", "\\N", "N/A", "-"),
  col_names = c("airline_id",
                "of_airline_id",
                "source_id",
                "of_source_id",
                "dest_id",
                "of_dest_id",
                "codeshare",
                "stops",
                "equipment"),
  col_types = strrep("c", 9)
)

countries <- read_csv(
  file = here::here("countries.dat"),
  trim_ws = TRUE,
  na = c("", "\\N", "N/A", "-"),
  col_names = c("name",
                "fips",
                "iso2",
                "group"),
  col_types = strrep("c", 4)
)

planes <- read_csv(
  file = here::here("planes.dat"),
  trim_ws = TRUE,
  na = c("", "\\N", "N/A", "-"),
  col_names = c("name",
                "iata",
                "icao"),
  col_types = strrep("c", 3)
)

save(
  airlines,
  airports,
  routes,
  planes,
  countries,
  file = here::here("openflights-org-20190920.Rdata")
)
