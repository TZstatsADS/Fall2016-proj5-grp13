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
dat.wordfreq0 <- GetTermFreq(dat.combine.dtm %>% filter(Label==0))
# 2-gram
dat.2gramfreq0 <- GetTermFreq(dat.2gram.dtm %>% filter(Label==0))
# 3-gram
dat.3gramfreq0 <- GetTermFreq(dat.3gram.dtm %>% filter(Label==0))

# for 1 (increased stock price)
dat.wordfreq1 <- GetTermFreq(dat.combine.dtm %>% filter(Label==1))
# 2-gram
dat.2gramfreq1 <- GetTermFreq(dat.2gram.dtm %>% filter(Label==1))
# 3-gram
dat.3gramfreq1 <- GetTermFreq(dat.3gram.dtm %>% filter(Label==1))

warning("Should we select Top 10 or 5 for each group of words (0 and 1 group)?")


# Data Assembling ##########################################################################

c(dat.wordfreq0$word[1:20])
c(dat.2gramfreq0$word[1:20])
c(dat.3gramfreq0$word[1:5])

c(dat.wordfreq1$word[1:20])
c(dat.2gramfreq1$word[1:20])
c(dat.3gramfreq1$word[1:5])

# 1-gram
dat.1gram.highfreq <- dat.combine.dtm[, c(1, which(colnames(dat.combine.dtm) 
                                                   %in% c("polic", "use", "forc", 
                                                          "attack", "protest", "call")))] 

colnames(dat.1gram.highfreq)[2:7] <- c("1_polic", "1_use", "1_forc", 
                                       "0_attack", "0_protest", "0_call")

# 2-gram 
dat.2gram.highfreq <- dat.2gram.dtm[, c(1, which(colnames(dat.2gram.dtm) 
                                                 %in% c("court rule", "polic offic", 
                                                        "climat chang", "south africa")))] 

colnames(dat.2gram.highfreq)[2:5] <- c("1_court_rule", "1_polic_offic", 
                                       "0_climat_chang", "0_south_africa")


# 3-gram 
dat.3gram.highfreq <- dat.3gram.dtm[, c(1, which(colnames(dat.3gram.dtm) 
                                                 %in% c("human right watch", "nobel peac prize", "first time sinc", 
                                                        "osama bin laden", "presid barack obama", "world war ii")))] 

colnames(dat.3gram.highfreq)[2:7] <- c("1_human_right_watch", "1_nobel_peac_prize", "1_first_time_sinc", 
                                       "0_osama_bin_laden", "0_presid_barack_obama", "0_world_war_ii")

# assemble all partitioned datasets
dat.tm <- dat.combine.dtm %>% 
  select(Date, Label, text_body) %>% 
  left_join(x = ., dat.1gram.highfreq, by = "Date") %>%
  left_join(x = ., dat.2gram.highfreq, by = "Date") %>%
  left_join(x = ., dat.3gram.highfreq, by = "Date")

# Data Saving #############################################################################
saveRDS(dat.tm, file = "output/dat_tm.rds")

# Data Combining #########################################################################
dat.w2v <- read.csv("output/avgw2v.csv", header=T)

dat.prediction <- dat.combine.dtm %>% 
  left_join(x=., y=dat.2gram.dtm, by = "Date") %>%
  left_join(x=., y=dat.3gram.dtm, by = "Date") %>% 
  left_join(x=., y=dat.w2v, by = "Date")

saveRDS(dat.prediction, file = "output/dat_prediction.rds")
write.csv(dat.prediction, "output/dat_prediction.csv")

