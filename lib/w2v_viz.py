import os
import sys
import numpy as np
import matplotlib.pyplot as plt
from gensim.models import Word2Vec
from sklearn.manifold import TSNE
 
 
os.chdir('/Users/pengfeiwang/Desktop/proj5/Fall2016-proj5-proj5-grp13/')

model = Word2Vec.load('./output/model.w2v')
vocabulary = list(set(model.index2word))
word_vec=[model[i].tolist() for i in vocabulary]

# init model
tsne = TSNE(n_components=2, random_state=0)
np.set_printoptions(suppress=True)

Y = tsne.fit_transform(word_vec)

# show the first 100 points
plt.scatter(Y[:100, 0], Y[:100, 1],marker='.')
for label, x, y in zip(vocabulary[:100], Y[:100, 0], Y[:100, 1]):
    plt.annotate(label, xy=(x, y), xytext=(0, 0), textcoords='offset points')

plt.show()