import numpy as np


N = 4

z = np.ones(N)

autMatrix = [[0,0,1,0],
			[1,0,0,0],
			[1,1,0,1],
			[0,0,0,0]]


hubMatrix = [[0,1,1,0],
			[0,0,1,0],
			[1,0,0,0],
			[0,0,1,0]]

autMatrix = np.array(autMatrix)
hubMatrix = np.array(hubMatrix)

x = []
y = []

x.append(z)
y.append(z)

k = 650

print(x)

def autUpdate(x,y):
	x = np.array(x)
	y = np.array(y)
	xTemp = np.zeros(x.shape)

	#print(type(autMatrix[1]))

	for i in range(x.shape[0]):
		#print(type(y[i]))
		xTemp[i] = autMatrix[i].dot(y)

	return xTemp

def hubUpdate(x,y):
	x = np.array(x)
	y = np.array(y)

	yTemp = np.zeros(y.shape)

	for i in range(y.shape[0]):
		yTemp[i] = hubMatrix[i].dot(x)

	return yTemp




for i in range(1,k):

	xTemp = autUpdate(x[i-1],y[i-1])
	yTemp = hubUpdate(xTemp,y[i-1])
	xTemp = xTemp/np.linalg.norm(xTemp)
	yTemp = yTemp/np.linalg.norm(yTemp)
	x.append(xTemp)
	y.append(yTemp)
	print(xTemp,'\n',yTemp,'\n' ,i)


print('Vetor de Autoridade :' ,x[k-1], '\nVetor de Hub :', y[k-1])

