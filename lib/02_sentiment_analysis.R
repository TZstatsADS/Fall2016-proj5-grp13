# Basic Setup #############################################################################
# load package
library(dplyr)
library(tidytext)


nrc <- sentiments %>%
  filter(lexicon == "nrc") %>%
  dplyr::select(word, sentiment)

nrc