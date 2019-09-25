library(tidyverse)
library(tm)

crear_txt_df <- function(fname) {
  txt <- readLines(fname, encoding = "utf-8") %>%
    str_replace("Art\\.", "articulo") %>%
    str_replace("art\\.", "artículo")
  docs <- Corpus(VectorSource(txt)) %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removeNumbers) %>%
    tm_map(removeWords, stopwords("es")) %>%
    tm_map(removeWords, c("artículo", "art", "articulo", "ser")) %>%
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace) %>%
    tm_map(stemDocument)
  tdm <- TermDocumentMatrix(docs)
  m <- as.matrix(tdm)
  v <- sort(rowSums(m),decreasing=TRUE)
  tibble(word = names(v),freq=v)
}

constitucion_peru = tibble()

for (fn in list.files("./", pattern = "*.txt")) {
  yr <- str_extract(fn, "1[0-9]{3}")
  df <- crear_txt_df(paste0("txt/", fn)) %>%
    mutate(
      yr = yr,
      angle = 90 * sample(c(0, 1), n(), replace = TRUE, prob = c(60, 40))
    )
  constitucion_peru <- constitucion_peru %>% bind_rows(df)
}

constitucion_peru <- constitucion_peru %>%
  arrange(
    yr, desc(freq)
  )

save(
  constitucion_peru,
  file = here::here("data/constitucion_peru_1812_1993.Rdata")
)



