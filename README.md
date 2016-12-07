# ADS Final Project: 

## Projec title: DJI trading strategy based on daily news 
+ Team members
	+ team member 1
	+ team member 2
	+ team member 3
	+ team member 4
	+ team member 5
	
## Project summary: 

Constructed trading strategy basing on top ranked daily news from reddict

#### About the dataset
![](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/figs/dataset.jpg)

#### Dataset Dummary
1. 1989x25 matrix
2. X is top-ranked news 
3. Y is label, representinf the movement of stock price, up or down
4. Data is the timestamp

## Data Cleaning
- Encoding utf-8
- Removed unnecessay stopwords: "a, the, I"
- Removed punctuation: "#.,"
- Stemmed words


## Feature Engineering
- [DTM](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/01_text_mining.R)
- [Sentiment Analysis](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/02_sentiment_analysis.R)
- [Word2vec](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/word2vec.py)
- [Doc2vec](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/doc2vec.py)
- [Bag of keywords](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/word2vec.py)

## Feature Selection
- Recursive Elimination Algorithm
- CV

## Model Selection
- Random Forest
- KNN
- Naive Bayes

## Strategy Construction


## Conclusion


**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
