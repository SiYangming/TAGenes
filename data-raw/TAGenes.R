library(XML)
library(tibble)
library(dplyr)

# urls <- paste0("http://www.binfo.ncku.edu.tw/cgi-bin/gf.pl?chromosome=", c(1:22, "X", "Y"))

urls <- paste0("data-raw/TAGList/",
               "TAG List by Chromosomal Location on ",
               c(1:22, "X", "Y"),
               ".html")
names(urls) <- c(1:22, "X", "Y")

tbls <- sapply(urls, function(x){
  readHTMLTable(x, header = TRUE)
})

tbl <- as_tibble(do.call(rbind, tbls))

TAGenes <- tbl %>%
  mutate(Chromosome =
           unlist(mapply(rep,
                         names(urls),
                         sapply(tbls, nrow))))

write_tsv(TAGenes, file = "data-raw/TAGenes.tsv")

save(TAGenes, file = "data/TAGenes.rda")
