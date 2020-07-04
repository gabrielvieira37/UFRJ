import nltk
import re
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn import metrics
from sklearn.model_selection import cross_val_predict
import numpy as np


np.set_printoptions(formatter={'float': lambda x: "{0:0.3f}".format(x)})

dataset = pd.read_csv('Tweets_Mg.csv')
#print(dataset.count())


tweets = dataset['Text'].values
classes = dataset['Classificacao'].values


#print(tweets)


vectorizer = CountVectorizer(analyzer="word")
freq_tweets = vectorizer.fit_transform(tweets)
modelo = MultinomialNB()
modelo.fit(freq_tweets,classes)

sentimento=['Positivo','Negativo','Neutro']
testes = ['Esse governo está no início, vamos ver o que vai dar',
         'Eu odeio o brasil',
         'O estado de Minas Gerais decretou calamidade financeira!!!',
         'A segurança desse país está deixando a desejar',
         'O governador de Minas é do PT']


freq_testes = vectorizer.transform(testes)
pred = modelo.predict_proba(freq_testes)*100

print(type(pred))
print(sorted(sentimento),'\n',pred)

resultados = cross_val_predict(modelo, freq_tweets, classes, cv=10)

print(metrics.accuracy_score(classes,resultados))



print (metrics.classification_report(classes,resultados,sentimento),'')


print (pd.crosstab(classes, resultados, rownames=['Real'], colnames=['    Predito'], margins=True), '')


vectorizer = CountVectorizer(ngram_range=(1,2))
freq_tweets = vectorizer.fit_transform(tweets)
modelo = MultinomialNB()
modelo.fit(freq_tweets,classes)

resultados = cross_val_predict(modelo, freq_tweets, classes, cv=10)
print(metrics.accuracy_score(classes,resultados))


print (metrics.classification_report(classes,resultados,sentimento))


print (pd.crosstab(classes, resultados, rownames=['Real'], colnames=['    Predito'], margins=True), '')

'''
vectorizer = TfidfVectorizer(ngram_range=(1,2))
freq_tweets = vectorizer.fit_transform(tweets)
modelo = MultinomialNB()
modelo.fit(freq_tweets,classes)

resultados = cross_val_predict(modelo, freq_tweets, classes, cv=10)
print(metrics.accuracy_score(classes,resultados))


print (metrics.classification_report(classes,resultados,sentimento))


print (pd.crosstab(classes, resultados, rownames=['Real'], colnames=['    Predito'], margins=True), '')
'''

#pos
#testes = ['Adoro drogas e tráfico']
#neg
#testes = ['O pau do pimentel ainda sobe']
#neu
#testes = ['O Estado de Minas Gerais é uma merda']

testes = input('\nEnter your input:')
testes = [testes]

freq_testes = vectorizer.transform(testes)
pred = modelo.predict_proba(freq_testes)*100

print(freq_testes)
print(type(pred))
print(sorted(sentimento),'\n',pred)

#print(vectorizer.get_feature_names())