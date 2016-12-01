import pandas as pd
from gensim.models import word2vec
from utils import *
from nltk.corpus import stopwords
import os,re


os.chdir('/Users/pengfeiwang/Desktop/proj5/Fall2016-proj5-proj5-grp13/')
dta = pd.read_csv('data/Combined_News_DJIA.csv', index_col=['Date'])

dta.isnull().sum(axis=1).sum()

y = dta['Label']
x = dta.drop('Label', axis=1)
x = x.applymap(lambda x: str(x))
# x['Combined'] = x.apply(lambda i: ''.join(str(i)), axis=1)
# x['Combined'] = x['Combined'].apply(lambda x: clean_sentence(x,True))

def clean_sentence(sentence ,remove_stopwords=True):
	import re
	punc = ["b\"", "b\'" ,"'","'","-","?",":","\"",",","&amp","(",")",";"]
	for i in punc:
		sentence = sentence.replace(i,' ')
	sentence = re.sub("[^a-zA-Z]"," ", sentence)
	sentence = sentence.lower().split()
	if remove_stopwords:
		stops = set(stopwords.words("english"))
		sentence = [w for w in sentence if not w in stops]
	return(sentence)


total = []
for i in range(x.shape[0]):
	for j in range(x.shape[1]):
		x.ix[i,j] = clean_sentence(x.ix[i,j])
		total.append(x.ix[i,j])
	if i%500==0:
		print i

# Set values for various parameters
num_features = 300    # Word vector dimensionality                      
min_word_count = 40   # Minimum word count                        
num_workers = 4       # Number of threads to run in parallel
context = 10          # Context window size                                                                                    
downsampling = 1e-3   # Downsample setting for frequent words

print 'Training model...'
model = word2vec.Word2Vec(sentences, workers=num_workers, \
            size=num_features, min_count = min_word_count, \
            window = context, sample = downsampling)

model_name = 'try'
model.save(model_name)
