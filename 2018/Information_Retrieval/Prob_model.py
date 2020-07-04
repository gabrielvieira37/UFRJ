
# coding: utf-8

import numpy as np
import re

docs = ['O peã e o caval são pec de xadrez. O caval é o melhor do jog',
        'A jog envolv a torr, o peã e o rei.','O peã lac o boi','Caval de rodei!',
        'Polic o jog no xadrez.']
#docs dos Slides
#docs = ['To do is to be. To be is to do.','To be or not to be. I am what i am.','I think therefore I am. Do be do be do.','Do do do, da da da. Let it be, let it be.']
consulta = 'xadrez peã caval torr'
#consulta dos slides
#consulta = 'to do'

stopWords = ['a', 'o', 'e', 'é', 'de', 'do', 'no','são']
#stopWords = ['a', 'o', 'e', 'é', 'de', 'no','são']
separadores = [' ',',','.','!','?'];

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
                lista.remove(token)
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
for token in sorted(uniqTerm):
    tokenDict[token] = ct
    ct+=1


matrixInc = np.zeros((tamUniqTerm,tamDocs))

print('\n',documentos)

# Criando a matriz de incidencias, usando o dicionario e o sistema de documentos para preencher a matriz de incidencia
j = -1
listDoc = []
listSetDoc = []
for doc in documentos:
    listDoc.append(doc)
    sDoc =set(doc)
    listSetDoc.append(sDoc)
    #print(sDoc, '  size -> ',len(sDoc))
    j = j + 1 
    for term in uniqTerm:
        i = tokenDict[term]
#         if (term in doc):
#             matrixInc[i,j] += 1
        docTemp = list(doc)
        while(term in docTemp):           
            docTemp.remove(term)
            matrixInc[i,j] += 1
        del docTemp
print('\n')
for n in range(matrixInc.shape[1]):
    print(' doc',n+1, end='')
print('\n Matriz de Incidencia: \n',matrixInc,'\n')



for item in tokenDict:
    print(' ',item , '' )

#Criando lista de frequencia dos termos individuais em cada documento separadamente (TF)
freqList = []
for doc in listDoc:
    freqDocDict = {}
    for item in doc:
        freqDocDict[item] = doc.count(item)
    freqList.append(freqDocDict)
 

    
print("")

#Criando lista de frequencia dos termos em cada documento (IDF)
c=0
listSetDict = {}
for doc in listSetDoc:
    listSetDict[c] = list(doc)
    c+=1

k=0

invFreqDict = {}
for item in tokenDict:
    invFreqDict[item] = 0

for key,value in listSetDict.items():
    for item in tokenDict:     
        if item in value:        
            c = invFreqDict[item]
            invFreqDict[item] = c+1


#making Tf Matrix then IDF matrix and at the end doing an element-wise multiplication

matrixTF = np.zeros((tamUniqTerm,tamDocs))

count = 0
for item in freqList:
    for word in item:
        x = tokenDict[word]
        matrixTF[x,count] = 1 + np.log2(item[word])
    count+=1

    
matrixIDF = np.zeros((tamUniqTerm,1))


print('\n Matriz TF: \n',matrixTF)

for word in invFreqDict:  
    x = tokenDict[word]
    matrixIDF[x,0] = np.log2(tamDocs/invFreqDict[word])
    
print('\n Vetor IDF:\n',matrixIDF)

matrixTFIDF = np.multiply(matrixIDF,matrixTF)
print('\n Matriz TF-IDF:\n',matrixTFIDF)

#ver posicoes da consulta na tabela de palavras

q = {}
for item in tokenDict:
    if item in consulta:
        q[item]=tokenDict[item]
    
rank = np.zeros((tamDocs,1))

#Cria Modelo Vetorial
for tam in range(tamDocs):
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
print('\n Rank dos documentos com a consulta q [Modelo vetorial] : \n',rank)


#Cria Modelo Probabilistico
rankProb = np.zeros((tamDocs,1))

query= {}
for item in tokenDict:
    if item in consulta:
        query[item] = invFreqDict[item]

tamTotalDocs = 0
for item in range(tamDocs):
    tamTotalDocs += len(docs[item])


mediaTamDoc = tamTotalDocs/tamDocs

for tam in range(tamDocs):
    k=1
    b=0.75 
    N = tamDocs
    tamDocAtual = len(docs[tam])
    bNum = 0
    bDen = 1
    sim = 0
    for i in query:
     
        x = (N-query[i]+0.5)/(query[i]+0.5)
        idx = tokenDict[i]
        if (matrixInc[idx,tam] != 0):
            bNum = (k+1) * matrixInc[idx,tam]
            bDen = k*((1-b) + b*(tamDocAtual/mediaTamDoc))+ matrixInc[idx,tam]
        bTermoI  = bNum/bDen
        sim += bTermoI*np.log2(x)
        
    rankProb[tam,0] = sim
    


print('\n consulta q: \n',consulta)
print('\n Rank dos documentos com a consulta q [Modelo Probabilistico] : \n',rankProb)




