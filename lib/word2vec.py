import os
import re
import pandas as pd
import numpy as np
from gensim.models import word2vec
from nltk.corpus import stopwords
from collections import Counter
from numpy import log


os.chdir('/Users/pengfeiwang/Desktop/proj5/Fall2016-proj5-proj5-grp13/')
dta = pd.read_csv('data/Combined_News_DJIA.csv', index_col=['Date'])

dta.isnull().sum(axis=1).sum()  # 7


def clean_sentence(sentence, remove_stopwords=True):
    import re
    punc = ["b\"", "b\'", "'", "'", "-", "?",
            ":", "\"", ",", "&amp", "(", ")", ";"]
    for i in punc:
        sentence = sentence.replace(i, ' ')
    sentence = re.sub("[^a-zA-Z]", " ", sentence)
    sentence = sentence.lower().split()
    if remove_stopwords:
        stops = set(stopwords.words("english"))
        sentence = [w for w in sentence if not w in stops]
    return(sentence)


def tdidf(alist):
    d_freq = len([i for i in alist if i != 0])
    idf = log(1989 / float(d_freq))
    tfidf = [i * idf for i in alist]
    return(tfidf)


def makeFeatureVec(words, model, num_features):
    featureVec = np.zeros((num_features,), dtype="float32")
    nwords = 0.
    index2word_set = set(model.index2word)
    for word in words:
        if word in index2word_set:
            nwords = nwords + 1.
            featureVec = np.add(featureVec, model[word])
    featureVec = np.divide(featureVec, nwords)
    return featureVec


y = dta['Label']
x = dta.drop('Label', axis=1)
x = x.applymap(lambda x: str(x))
x_com = pd.DataFrame()
x_com['Combined'] = x.apply(lambda i: ''.join(str(i)), axis=1)
x_com['Combined'] = x_com['Combined'].apply(lambda i: clean_sentence(i, True))
# x_com['dict'] = [dict(Counter(x_com['Combined'][i])) for i in range(x.shape[0])]


# construct the corpus
total = []
for i in range(x.shape[0]):
    for j in range(x.shape[1]):
        x.ix[i, j] = clean_sentence(x.ix[i, j])
        total.append(x.ix[i, j])
    if i % 500 == 0:
        print i

# Set values for various parameters
num_features = 300    # Word vector dimensionality
min_word_count = 40   # Minimum word count
num_workers = 4       # Number of threads to run in parallel
context = 10          # Context window size
downsampling = 1e-3   # Downsample setting for frequent words

print 'Training model...'
model = word2vec.Word2Vec(total, workers=num_workers,
                          size=num_features, min_count=min_word_count,
                          window=context, sample=downsampling)

model_name = 'try'
model.save(model_name)


# boK + tfidf
bok = ['', '', '', '']
while len(bok) <= 1000:
    for i in bok[-10]:
        bok.append(model.most_similar(i)[0][0])

x['dict'] = [{k: v for k, v in i.iteritems() if k in bok} for i in x['dict']]
df = pd.DataFrame([{k: v for k, v in i.items()} for i in x['dict']])
df = df.fillna(0)
df = df.apply(lambda x: tdidf(x), axis=0)
df.to_csv('data/boK_tfidf.csv')

# avgw2v
avgw2v = pd.DataFrame(columns=[range(300)], index=x_com.index)
for i in range(len(x_com)):
    avgw2v.ix[i, :] = makeFeatureVec(x_com.ix[i, 0], model, num_features)

avgw2v.to_csv('data/avgw2v.csv')
