import sys
import os
import re
import pandas as pd
import numpy as np
from random import shuffle
from gensim.models import Doc2Vec
from gensim.models.doc2vec import TaggedDocument


os.chdir('/Users/pengfeiwang/Desktop/proj5/Fall2016-proj5-proj5-grp13/')
dta = pd.read_csv('data/Combined_News_DJIA.csv', index_col=['Date'])

y = dta['Label']
x = dta.drop('Label', axis=1)
x = x.applymap(lambda x: re.sub("b['\"]", '', str(x)))
x = x.applymap(lambda x: re.sub(r"[^a-zA-Z]", ' ', str(x)))


total_news = []
k = 0
for i in range(x.shape[0]):
    for j in range(x.shape[1]):
        total_news.append(
            TaggedDocument(x.ix[i, j].split(), [str(i) + '_' + str(k)]))
        k += 1


model = Doc2Vec(min_count=1, window=10, size=500, sample=1e-4, negative=5, alpha=0.025, min_alpha=0.025)
model.build_vocab(total_news)
for epoch in range(10):
    model.train(total_news)
    model.alpha -= 0.002  
    model.min_alpha = model.alpha 

# model.save('../output/model.doc2vec')
# model = Doc2Vec.load('../output/model.doc2vec')

tag_name = [total_news[i][1][0] for i in range(len(dta))]
train_arrays = np.zeros((1989, 500))

for i in range(dta.shape[0]):
	train_arrays[i] = np.mean([model.docvecs[j] for j in tag_name if j.split('_')[0] == str(i)],axis=0)


np.savetxt('output/d2v.csv', train_arrays, delimiter=",")
