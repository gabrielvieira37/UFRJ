
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



for item in sorted(tokenDict):
    print(' ',item , '' )


q = {}
for item in tokenDict:
    if item in consulta:
        q[item]=tokenDict[item]

#print(q)

query = np.zeros((tamUniqTerm,1))
#print(query)

itensList = []

for it in sorted(q):
	key = q[it]
	query[key] = 1
	
	#print(matrixInc[key,:])
	itensList.append(matrixInc[key,:])
	

print('\nConsulta: \n',query)

print('\nAnd:')

bitString = itensList[0]

#print(bitString>0)

for itens in itensList[1:]:

	aux = bitString>0

	bitString = np.logical_and(aux,(itens>0))

	 
print(bitString)


print('\nOr:')

bitString = itensList[0]

#print(bitString>0)

for itens in itensList[1:]:

	aux = bitString>0

	bitString = np.logical_or(aux,(itens>0))

print(bitString)

