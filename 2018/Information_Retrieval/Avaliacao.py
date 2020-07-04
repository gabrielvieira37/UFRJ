
# coding: utf-8



import numpy as np
import re
import matplotlib.pyplot as plt

docs = ['O peã e o caval são pec de xadrez. O caval é o melhor do jog',
        'A jog envolv a torr, o peã e o rei.','O peã lac o boi','Caval de rodei!',
        'Polic o jog no xadrez.']
#docs dos Slides
#docs = ['To do is to be. To be is to do.','To be or not to be. I am what i am.','I think therefore I am. Do be do be do.','Do do do, da da da. Let it be, let it be.']
consulta = 'xadrez peã caval torr'
#consulta dos slides
#consulta = 'to do'
relevantes = [1,2]

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
    
rank = np.zeros((tamDocs,2))

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
    #indice começa em 0 
    rank[tam,1] = sim
    rank[tam,0] = tam+1
    
rank = sorted(rank, key=lambda rank_entry:-rank_entry[1])
rank = np.array(rank)
        
print('\n consulta q: \n',consulta)
print('\n Rank dos documentos com a consulta q [Modelo vetorial] : \n',rank)


#Cria Modelo Probabilistico
rankProb = np.zeros((tamDocs,2))

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
    sim = 0
    for i in query:
        bNum = 0
        bDen = 1
        bTermoI = 0
        x = (N-query[i]+0.5)/(query[i]+0.5)

        idx = tokenDict[i]
        if (matrixInc[idx,tam] != 0):
            bNum = (k+1) * matrixInc[idx,tam]
            bDen = k*((1-b) + b*(tamDocAtual/mediaTamDoc))+ matrixInc[idx,tam]
        bTermoI  = bNum/bDen
        sim += bTermoI*np.log2(x)
        
    #indice começa em 0    
    rankProb[tam,0] = tam+1
    rankProb[tam,1] = sim
    
#ordena o array 
rankProb = sorted(rankProb, key=lambda rank_entry:-rank_entry[1])
rankProbPositive = [ num for num in rankProb if num[1] >=0 ]
rankProbPositive = np.array(rankProbPositive)

print('\n consulta q: \n',consulta)
print('\n Rank dos documentos com a consulta q [Modelo Probabilistico] : \n',rankProbPositive)

        

### Função de avaliação do modelo de RI

#Recall and Precision

def recallAndPrecision(rank,relevantes):
    relevantes = np.array(relevantes)
    recall = len(np.intersect1d(rank[:,0],relevantes)) / len(relevantes)
    precision = len(np.intersect1d(rank[:,0],relevantes)) / len(rank[:,0])
    return recall,precision


recall,precision = recallAndPrecision(rankProbPositive,relevantes)

print('\n Modelo Probabilistico')
print('\n','Recall: ',recall,' Precision: ',precision)


def fMeasure(beta,recall,precision):
    num = (1+(beta**2)) * precision * recall
    den = ((beta**2) *precision) + recall
    f = num/den
    return f

#F1
F1 =fMeasure(1,recall,precision)
print('\n','F1: ',F1)

#Recall and precision for each recovered relevant

def recallAndPrecisionRecoveredRelevant(ranks,relevantes):
	recPrecList = []
	count = 0
	relevantes = np.array(relevantes)
	recPrecValues = np.zeros((len(relevantes),2))
	for i in range(len(ranks)):
		recPrecList.append(ranks[i])
		for j in range(len(relevantes)):
			if (ranks[i,0] == relevantes[j]):

				recPrec = np.array(recPrecList)
				recall,precision = recallAndPrecision(recPrec,relevantes)
				recPrecValues[count,0] = recall
				recPrecValues[count,1] = precision
				count +=1

	return recPrecValues

recPrecMatrix = recallAndPrecisionRecoveredRelevant(rankProbPositive,relevantes)
print('\n', 'Recall and Precision for each relevant:\n', recPrecMatrix)




#interpoled precision for each level from 0.0 to 1.0
def interpoledPrecision(recPrecMatrix):
	recPrecMatrixSorted = sorted(recPrecMatrix, key=lambda recProb_entry:recProb_entry[0])	
	recPrecMatrixSorted = np.array(recPrecMatrixSorted)
	space = np.linspace(0.0,1.0,num=11)
	interpol = np.zeros((11,2))
	for i,item in enumerate(space):
		
		trigger = 1
		count=0
		while(trigger):
			if (item<=recPrecMatrixSorted[count,0]):
				interpol[i,0] = item
				interpol[i,1] = recPrecMatrixSorted[count,1]
				trigger=0
			else:
				count+=1

	return interpol

interp = interpoledPrecision(recPrecMatrix)
print('\n','Precisão interpolada (Recall, Precision):\n',interp)

plt.plot(interp[:,0],interp[:,1])
plt.axis([-0.1,1.1,-0.1,1.1])
plt.show()

#Mean average precision
def MAP(recPrecMatrix,relevant):
	sizeRelated = len(relevant)
	mapR = (1/sizeRelated)*np.sum(recPrecMatrix[:,1])
	return mapR

mapR = MAP(recPrecMatrix,relevantes)

print('\nMAP:',mapR)