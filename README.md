# ADS Final Project: 

## Projec title: DJI trading strategy based on daily news 
+ Team members
	+ Han Cui
	+ Peiran Fang
	+ Yanjin Li
	+ Pengfei Wang
	
## Project summary: 

Constructed trading strategy basing on top ranked daily news from reddict

#### About the dataset
![](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/figs/dataset.jpg)

#### Dataset Summary
1. 1989x25 matrix
2. X is top-ranked news 
3. Y is label, representinf the movement of stock price, up or down
4. Data is the timestamp

## Data Cleaning/Text Mining
- Encoding utf-8
- Convert to lowercase
- Remove unnecessary numbers
- Delete english stopwords, such as "wouldn't", "not", "you", etc.
- Remove punctuations, such as "$", ",", etc.
- Stemmed words by deleting common endings, such as -s, -ed, -ing, etc.
- Remove sprase terms, such as names, etc. 


## Feature Engineering
- [DTM](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/01_text_mining.R)
- [Sentiment Analysis](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/02_sentiment_analysis.R)
- [Word2vec](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/word2vec.py)
- [Doc2vec](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/doc2vec.py)
- [Bag of keywords](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/lib/word2vec.py)

## Feature Selection
- Recursive Elimination Algorithm
- CV

## Data Visualization
In this section, our main goal is to show how uni-gram, bi-gram and tri-gram terms differ from each other among all new titles since 2008 to now. 
![](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/figs/3-gram_highfreq_word.png?raw=true)
![](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/figs/2-gram_highfreq_word.png?raw=true)

In terms of the visualization of Word2vec model, we simply choose the first 100 words as an example.
![](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/figs/w2v_first_100.png)
As we can see in the scatter plot, the word air and military have quite close distance, which could otherwise not happend in the traditional NLP, like Jaccord distance or ngram method.

## Model Selection
- Random Forest
- KNN
- Naive Bayes

## Strategy Construction
In this section, we change thereshold values to generate different levels of prediction granularities. 
![](https://github.com/TZstatsADS/Fall2016-proj5-proj5-grp13/blob/master/figs/stock_pred_plot.png?raw=true) 

## Conclusion
+ Label Accuracy Rate: 56.94%

+ Threshold Optimization: 

  Algorithm: gird search optimization (maximize Sharpe Ratio)
  
  Long-only strategy: < 0.4, labelled 1; >0.4 labelled 0 
  
  Long-short strategy: <0.4, labelled 1; >0.7, labelled 0
  
+ Optimization Result:

  Benchmark (DJIA): Sharpe Ratio 0.011
  Long-only strategy: Sharpe Ratio 0.044
  Long-short strategy: Sharpe Ratio 0.040




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
