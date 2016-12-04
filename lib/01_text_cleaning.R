# Basic Setup
# Data Loading
# Text Mining



# Basic Setup #############################################################################
# load package
library(dplyr)
library(tidyr)
library(NLP)
library(tm)

# set working directory
setwd("/Users/yanjin1993/GitHub/Fall2016-proj5-proj5-grp13/")

# code library: "lib/"
# data source: "data/" {Combined_News_DJIA.csv, DJIA_table.csv, RedditNews.csv}
# documentations: "doc/"
# figures: "figs/"
# output files: "output/"


# Data Loading #############################################################################
datraw.djia <- read.csv("data/DJIA_table.csv", header=T)
datraw.redditnews <- read.csv("data/RedditNews.csv", header=T)
datraw.combine <- read.csv("data/Combined_News_DJIA.csv", header=T)

dat.djia <- datraw.djia             # DJIA stock prices data
dat.redditnews <- datraw.redditnews # news titles data
dat.combine <- datraw.combine %>%  # DJIA's top news titles data (combined)
  mutate(text_body = paste(Top1, Top2, Top3, Top4, Top5, 
                           Top6, Top7, Top8, Top9, Top10,
                           Top11, Top12, Top13, Top14, Top15,
                           Top16, Top17, Top18, Top19, Top20,
                           Top21, Top22, Top23, Top24, Top25)) 
dat.combine$text_body <- gsub("b'", " ", dat.combine$text_body) 
warning("b'' is still left in text")

# Text Mining #############################################################################
doc <- Corpus(VectorSource(dat.combine$text_body))

# convert to lowercase
doc <- tm_map(doc, content_transformer(tolower))
# remove numbers
doc <- tm_map(doc, content_transformer(removeNumbers))
# delete english stopwords. See list: stopwords("english")
doc <- tm_map(doc, removeWords, stopwords("english"))
# remove punctuations
doc <- tm_map(doc, content_transformer(removePunctuation))
# delete common word endings, like -s, -ed, -ing, etc.
doc <- tm_map(doc, stemDocument, language = "english")
# delete multi-whitespace 
doc <- tm_map(doc, content_transformer(stripWhitespace))

# convert to Document Term Marix
dtm <- DocumentTermMatrix(doc)
dim(dtm) # dim = 1989 by 26170

# remove sparsity
dtm.nonsparse <- removeSparseTerms(dtm, 1.00 - 0.10)
dim(dtm.nonsparse) # dim = 1989 by 556

# convert to dataframe
dat.combine.dtm <- cbind(Date = dat.combine$Date, 
                   Label = dat.combine$Label,
                   text_body = dat.combine$text_body,
                   as.data.frame(as.matrix(dtm.nonsparse)))


# N-gram Text Mining #########################################################################
# helper function
GetNgramDf <- function(doc, n, sparsity) {
  # DESCRITPION: Return n-gram dataframes 
  # RETURN VALUES: dataframe
  return.list <- list()
  
  NGramTokenizer <- function(x) 
    unlist(lapply(ngrams(words(x), n), paste, collapse = " "), use.names = FALSE)
  
  ngram.dtm <- DocumentTermMatrix(doc, control = list(tokenize = NGramTokenizer))
  ngram.dtm.nonsparse <- removeSparseTerms(ngram.dtm, 1.00 - sparsity)
  ngram.dtm.df <- cbind(Date = dat.combine$Date, 
                        Label = dat.combine$Label,
                        text_body = dat.combine$text_body,
                        as.data.frame(as.matrix(ngram.dtm.nonsparse)))
  return.list[["dtm"]] <- ngram.dtm
  return.list[["dtm.df"]] <- ngram.dtm.df
  return(return.list)
}

# get 2-gram 
gram2 <- GetNgramDf(doc, 2, 0.03) # dim = 1989 by 122
dat.2gram.dtm <- gram2$dtm.df

# get 3-gram 
gram3 <- GetNgramDf(doc, 3, 0.01)
dat.3gram.dtm <- gram3$dtm.df    # dim = 1989 by 58


# Data Partition #############################################################################
# word ranking for 0 and 1 

# helper function
GetTermFreq <- function(input_data) {
  # input: a DTM data frame 
  # value: a term frequency table
  data <- input_data %>%
    gather(word, frequency, -c(text_body, Date, Label)) %>%
    filter(frequency != 0) %>%
    group_by(word) %>%    
    summarise(num = n()) %>%            
    arrange(desc(num))
  return(data)
}

# for 0 (decreased stock price)
# 1-gram
dat.comb.dtm0 <- dat.combine.dtm %>% filter(Label==0)
dat.wordfreq0 <- GetTermFreq(dat.comb.dtm0)
# 2-gram
dat.2gram.dtm0 <- dat.2gram.dtm %>% filter(Label==0)
dat.2gramfreq0 <- GetTermFreq(dat.2gram.dtm0)

# for 1 (increased stock price)
dat.comb.dtm1 <- dat.combine.dtm %>% filter(Label==1)
dat.wordfreq1 <- GetTermFreq(dat.comb.dtm1)

warning("Should we select Top 10 or 5 for each group of words (0 and 1 group)?")












