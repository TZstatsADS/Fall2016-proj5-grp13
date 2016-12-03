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


model = Doc2Vec(min_count=1, window=10, size=100, sample=1e-4, negative=5)
model.build_vocab(total_news)

for epoch in range(10):
    print str(i) + '/10'
    model.train(shuffle(total_news))

tag_name = [total_news[i][1][0] for i in range(len(dta))]
train_arrays = numpy.zeros((1989, 100))

for i in range(dta.shape[0]):
    train_arrays[i] = np.mean([model.docvecs[j]
                               for j in tag_name if j.split('_')[0] == i], axis=1)


test_arrays.to_csv('d2v.csv')
