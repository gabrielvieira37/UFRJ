
# coding: utf-8

# In[43]:


import numpy as np
import re
from numpy import linalg

docs = ['O peã e o caval são pec de xadrez. O caval é o melhor do jog','A jog envolv a torr, o peã e o rei.','O peã lac o boi','Caval de rodei!','Polic o jog no xadrez.']
consulta = 'xadrez peã caval torr'
stopWords = ['a', 'o', 'e', 'é', 'de', 'do', 'no','são']
separadore = [',','.','!','?'];
separadores = [' ',',','.','!','?'];

#print(type(docs))
documentos = docs
consulta = consulta.lower()

#Normaliza para caixa baixa
def normalizeTxt(docs):
    for doc in docs:
        aux = docs.index(doc)
        doc = doc.lower()
        docs[aux] = doc
    return docs

docs = normalizeTxt(docs)

#Remove pontuação
for line in docs:
    docs[docs.index(line)] = re.findall(r"[\w']+", line)

#Remove stopwords
for lista in docs:
    for token in lista:
        while(token in lista):
            if(token in stopWords):
                lista.remove(token) #pylint ignored-classes:E1101
            else:
                break

#Colocando todos os tokens em uma unica lista
auxDoc = []
for doc in docs:
    auxDoc += doc

#quantidade de documentos no sistema
tamDocs = len(docs)
#tokens unicos em todos os documentos
uniqTerm = set(auxDoc) 
tamUniqTerm = len(uniqTerm)

uniqTerm = sorted(uniqTerm)

#Dicionario com os tokens unicos, para fazer uma matriz correlacionando o indice da string no dicionario
tokenDict = {}
ct = 0
for token in uniqTerm:
    tokenDict[token] = ct
    ct+=1


matrixInc = np.zeros((tamUniqTerm,tamDocs))


# Criando a matriz de incidencias, usando o dicionario e o sistema de documentos para preencher a matriz de incidencia
j = -1
listDoc = []
listSetDoc = []
for doc in documentos:
    listDoc.append(doc)
    sDoc =set(doc)
    listSetDoc.append(sDoc)
    print(sDoc, '  size -> ',len(sDoc))
    j = j + 1 
    for term in uniqTerm:
        i = tokenDict[term]
        if (term in doc):
            matrixInc[i,j] = 1
print('\n')
for n in range(matrixInc.shape[1]):
    print(' doc',n+1, end='')
print('\n',matrixInc,'\n')

for item in sorted(tokenDict):
    print(' ',item , '' )

#Criando lista de frequencia dos termos em cada documento (TF)
freqList = []
#print("\n","freq:")
for doc in listDoc:
    #print('\n',doc)
    freqDocDict = {}
    for item in doc:
        #print(item," ")
        #print(doc.count(item))
        freqDocDict[item] = doc.count(item)
    freqList.append(freqDocDict)
 
'''
for item in freqList:
    print(item)
'''
    
print("")

#Criando IDF
#print("invFreq:")
c=0
listSetDict = {}
for doc in listSetDoc:
    #print(doc)
    listSetDict[c] = list(doc)
    c+=1
    
#print(listSetDict)
k=0

invFreqDict = {}
for item in tokenDict:
    invFreqDict[item] = 0

#print(invFreqDict)
for key,value in listSetDict.items():
    for item in tokenDict:     
        #print(value)
        if item in value:
            #print('tem',item)
            c = invFreqDict[item]
            invFreqDict[item] = c+1

#print(tokenDict)

#print('\n',invFreqDict,'\n')

#making Tf Matrix then IDF matrix and at the end doing an element-wise multiplication

matrixTF = np.zeros((tamUniqTerm,tamDocs))

count = 0
for item in freqList:
    for word in item:
        x = tokenDict[word]
        #print(word,'',x)       
        #print(item[word])
        matrixTF[x,count] = 1 + np.log2(item[word])
    count+=1

    
matrixIDF = np.zeros((tamUniqTerm,1))

#print('\n',tokenDict)

print('\n Matriz TF: \n',matrixTF)

for word in invFreqDict:  
    #print(word,invFreqDict[word])
    x = tokenDict[word]
    matrixIDF[x,0] = np.log2(tamDocs/invFreqDict[word])
    
print('\n Matriz IDF:\n',matrixIDF)
matrixTFIDF = np.multiply(matrixIDF,matrixTF)
print('\n Matriz TF-IDF:\n',matrixTFIDF)

#ver posicoes da consulta na tabela de palavras

#print(tokenDict)
q = {}
for item in tokenDict:
    if item in consulta:
        q[item]=tokenDict[item]
    
#print(sorted(q))    
rank = np.zeros((tamDocs,1))
for tam in range(matrixTFIDF.shape[1]):
    docMod = 0
    num = 0
    querMod =0
    for i in q:
        
        num += matrixTFIDF[q[i],tam] * matrixIDF[q[i]]              
        querMod += matrixIDF[q[i]]**2
    docMod = np.sum(matrixTFIDF[:,tam]**2)
    den = np.sqrt(docMod)*np.sqrt(querMod)
    sim = num/den
    rank[tam,0] = sim
        
print('\n consulta q: \n',consulta)
print('\n Rank dos documentos com a consulta q : \n',np.sort(rank))

