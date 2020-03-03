import cv2
import numpy as np
import argparse
import math
from matplotlib.pyplot import figure, show
from scipy.sparse.linalg import *
from scipy.sparse import *
from scipy import *
import time

#Lendo a imagem
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required = True,
help = "Path to the image")
args = vars(ap.parse_args())

image = cv2.imread(args["image"])
cv2.imshow("Original", image)

#transformando a imagem em tons de cinza
gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)

print(gray.shape)
(x,y) = gray.shape
print(gray)
print(x,y)


F = np.copy(gray)
F = F.astype(np.int32)



nPixels = x*y




row = []
column = []
data = []

counter = 1
sigma = 15
sigma = sigma ** 2
#O sigma faz o range de valores avaliados aumente.
#Para todos os pixels verificar as vizinhanças dos mesmos e ver a diferença nos tons de cinza
for i in range(nPixels):
		if y>x:
			idxI = i/y
			idyI = i%y
			counter = 0
		else:
			idxI = i/x
			idyI = i%x


		#print("Xi:"+str(idxI) +" Yi:" + str(idyI))
		#print("Xj:"+str(idxJ) +" Yj:" + str(idyJ))

		#noroeste
		idxJ = idxI -1
		idyJ = idyI -1
		if idxI >0 and idyI >0 :
			if counter :
				j = (idxJ * x) + idyJ
			else:
				j = (idxJ * y) + idyJ
			s = F[idxI,idyI]
			z = F[idxJ,idyJ]
			diff = s-z
			#print(diff)
			#W[i,j] = diff
			diff = np.square(diff)/sigma

			row.append(i)
			column.append(j)
			data.append(np.exp(-diff))

			#W[i,j] = np.exp(-diff)


		#norte
		idxJ = idxI -1
		idyJ = idyI
		if idxI >0:
			if counter :
				j = (idxJ * x) + idyJ
			else:
				j = (idxJ * y) + idyJ
			s = F[idxI,idyI]
			z = F[idxJ,idyJ]
			diff = s-z
			#print(diff)
			#W[i,j] = diff
			diff = np.square(diff)/sigma
			row.append(i)
			column.append(j)
			data.append(np.exp(-diff))
			
			#W[i,j] = np.exp(-diff)

		#nordeste
		idxJ = idxI -1
		idyJ = idyI +1
		if idxI >0 and idyI<(y-1):
			if counter :
				j = (idxJ * x) + idyJ
			else:
				j = (idxJ * y) + idyJ
			s = F[idxI,idyI]
			z = F[idxJ,idyJ]
			diff = s-z
			#print(diff)
			#W[i,j] = diff
			diff = np.square(diff)/sigma
			row.append(i)
			column.append(j)
			data.append(np.exp(-diff))
			
			#W[i,j] = np.exp(-diff)

		#centroeste
		idxJ = idxI 
		idyJ = idyI -1
		if idyI>0:
			if counter :
				j = (idxJ * x) + idyJ
			else:
				j = (idxJ * y) + idyJ
			s = F[idxI,idyI]
			z = F[idxJ,idyJ]
			diff = s-z
			#print(diff)
			#W[i,j] = diff
			diff = np.square(diff)/sigma
			row.append(i)
			column.append(j)
			data.append(np.exp(-diff))
			
			
			#W[i,j] = np.exp(-diff)

		#centroleste
		idxJ = idxI
		idyJ = idyI + 1
		if idyI < (y-1):
			if counter :
				j = (idxJ * x) + idyJ
			else:
				j = (idxJ * y) + idyJ
			s = F[idxI,idyI]
			z = F[idxJ,idyJ]
			diff = s-z
			#print(diff)
			#W[i,j] = diff
			diff = np.square(diff)/sigma
			row.append(i)
			column.append(j)
			data.append(np.exp(-diff))
			
			
			#W[i,j] = np.exp(-diff)

		#suldoeste
		idxJ = idxI +1
		idyJ = idyI -1
		if idxI < (x-1) and idyI>0:
			if counter :
				j = (idxJ * x) + idyJ
			else:
				j = (idxJ * y) + idyJ
			s = F[idxI,idyI]
			z = F[idxJ,idyJ]
			diff = s-z
			#print(diff)
			#W[i,j] = diff
			diff = np.square(diff)/sigma
			row.append(i)
			column.append(j)
			data.append(np.exp(-diff))
			
			
			#W[i,j] = np.exp(-diff)

		#sul
		idxJ = idxI+1
		idyJ = idyI
		if idxI <(x-1):
			if counter :
				j = (idxJ * x) + idyJ
			else:
				j = (idxJ * y) + idyJ
			s = F[idxI,idyI]
			z = F[idxJ,idyJ]
			diff = s-z
			#print(diff)
			#W[i,j] = diff
			diff = np.square(diff)/sigma
			row.append(i)
			column.append(j)
			data.append(np.exp(-diff))
			
			
			#W[i,j] = np.exp(-diff)

		#suldeste
		idxJ = idxI +1
		idyJ = idyI +1
		if idxI <(x-1) and idyI <(y-1):
			if counter :
				j = (idxJ * x) + idyJ
			else:
				j = (idxJ * y) + idyJ
			s = F[idxI,idyI]
			z = F[idxJ,idyJ]
			diff = s-z
			#print(diff)
			#W[i,j] = diff
			diff = np.square(diff)/sigma
			row.append(i)
			column.append(j)
			data.append(np.exp(-diff))
			

			#W[i,j] = np.exp(-diff)


row = np.asarray(row)
column = np.asarray(column)
data = np.asarray(data)

W = csr_matrix( (data,(row,column)) ,shape=(nPixels,nPixels), dtype="int16" )


print("W: ")
print(W)

D = W.sum(axis=1)
(u,_)= D.shape
linha = []
coluna = [] 
dado =[]
for i in range(u):
	linha.append(i)
	coluna.append(i)
	dado.append(D[i,0])


D = csr_matrix( (dado,(linha,coluna)),shape=(nPixels,nPixels) )

dRoot = D.power(-(0.5))

print("D: ")
print(D)
L = D-W
print("Laplacian: ")
print(L)

np.set_printoptions(precision=2)
print("dRoot: ")
print(dRoot)

norm = dRoot.dot(L)
norm = norm.dot(dRoot)
normL = norm.copy()
print("Normalized Laplacian: ")
print(normL)

print("\nNormalized Laplacian numbers: ")
nonZero = normL.getnnz()
print(nonZero)
print("\nSao menores que 9*numero de pixels ? ")
print(nonZero < nPixels * 9 )
print("\n")

tic= time.time()
eigValue,eigVector = scipy.sparse.linalg.eigsh(normL,k=2, which='SA', maxiter=1000 , tol=1e-5)
toc = time.time()

print("Auto-Valores: \n{:}\n".format(eigValue))


print("Segundo menor auto-valor: {:.4}\n".format(eigValue[1]))

np.set_printoptions(precision=5)
vec = eigVector[:,1]

print("Auto-vetor associado ao segundo menor auto-valor: \n{:}".format(vec))

vecMean = np.mean(vec)


print(vecMean)
vec = vec > vecMean
print(vec)

#Pinta os pixels do cluster A como 255 e os do B como 0
for i in range(nPixels):
	if y>x:
			idxI = i/y
			idyI = i%y
	else:
			idxI = i/x
			idyI = i%x


	if(vec[i]):
		gray[idxI,idyI] = 255
	else:
		gray[idxI,idyI] = 0




cv2.imshow("Gray",gray)
#cv2.imwrite("ne2w10.jpg", gray)


cv2.waitKey(0)


#Plot da esparsidade das matrizes
fig = figure()


ax1 = fig.add_subplot(221)

ax2 = fig.add_subplot(222)


ax3 = fig.add_subplot(223)




ax1.spy(W,markersize=0.5)
ax2.spy(D,markersize=0.5)

ax3.spy(L,markersize=0.5)

show()

print('\n\nCalculo de Autovalores demorou :', str(((toc-tic))/1) + 's')