# regenerate README.md
rmarkdown::render(
  input = "webinar-viz-covid19.Rmd",
  output_file = "webinar-viz-covid19.html"
)
