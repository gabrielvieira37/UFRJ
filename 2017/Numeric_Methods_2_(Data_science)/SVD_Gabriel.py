#Nome: Gabriel Dos Santos Vieira
#DRE: 114029198
import numpy as np


def pot(Matrix):
	n = Matrix.shape[1]
	v = np.random.randint(10, size=(n,1))
	
	#Diferenca ao quadrado entre a norma do vetor na iteracao k+1 e k  (eg: {norm[Vk+1]] - norm[Vk]}**2  )
	diff = 1

	vNormNew = 0

	while (diff > 10**(-20)) :

		# separa a norma da iteracao anterior para comparacao
		vNormOld = vNormNew

		v = np.dot(Matrix,v)
		# pega a norma do novo vetor v
		vNormNew = np.linalg.norm(v)

		#faz a diferenca ao quadrado das normas
		diff = vNormNew - vNormOld
		diff = diff **2
		
		# normaliza o vetor
		v = v/vNormNew


	return v


def eig(Matrix):
	
	A = Matrix
	A = np.array(A)

	eigenVectors = []
	eigenValues = []

	meanMatrix = 1
	aNew = A
	count = 1

	# quando media dos elementos da matriz for proximo de 0, significa que ja tiramos todos os autovetores de dentro da matriz.
	while (meanMatrix > 10**(-3)):
		v = pot(aNew)
		#print("vetor " + str(count))
		#print(v)
		eigenVectors.append(v)

		# em cada iteracao faz a Matriz A menos a projecao dela em cada um dos autovetores ja encontrados para encontrar o proximo autovetor.
		for v in eigenVectors:			
			vec = np.dot(aNew,v)
			vec = np.dot(vec,v.T)			
			aNew =  aNew - vec
		

		
		meanMatrix = np.mean(aNew)

		#utilize para ver o valor da media dos valores da matriz decrescendo a cada rodada
		#print("media dos elementos da matriz A nesta rodada : ")
		#print(meanMatrix)
		#print ""
		count += 1

	#achando os autovalores com vT * A * v = lambda vTv = lambda
	for vetores in eigenVectors:
		w = np.dot(A,vetores)
		eigenValues.append(np.dot(vetores.T, w))




	l,v = np.linalg.eig(A)

	# ordenando os Auto Valores e Auto Vetores do numpy
	idx = l.argsort()[::-1]
	l = l[idx]
	v = v[:,idx]

	# em caso de comparacao tirar os comentarios do prints abaixo
	#print("numpy eigenVectors")
	#print(v)
	#print("numpy eigenValues")
	#print(l)

	eigenValues = np.array(eigenValues)
	eigenVectors = np.array(eigenVectors)

	return eigenValues, eigenVectors

def svd(matrix):

	matrix = np.array(matrix)
	#pegando a matriz e fazendo ela como M.T*M teremos v * sigma2 * v.T 
	m = np.dot(matrix.T,matrix)

	#fazendo os eigenvectors do M*M.T teremos v
	sig2 , v = eig(m)

	#sabemos que A = sigma1 * u1 * v1_t + sigma2 *u2* v2_t + ... , entao se fizermos A*v teremos 
	#Av = sigma* u * v_t * v , como v_t * v = 1 teremos Av= sigma * u

	uSig = np.dot(matrix,v)


	#para retiramos o sigma e ficar apenas com u normalizaremos o vetor Usig
	for col in range(uSig.shape[1]):
		uSig[:,col] /= np.linalg.norm(uSig[:,col])


	u = 0
	# apenas um metodo para concatenar as colunas do U
	for n in range(uSig.shape[0]):
		if (np.mean(u) == 0):
			u = uSig[n]

		else:
			u = np.concatenate((u,uSig[n]),axis=1)	

	# a dimensao da matriz u estava incorreta, estava (m,n) quando deveria ser (n,m)
	u = u.T

	#print "matriz U"
	#print u


	
	
	vCol = v
	v = 0
	# apenas um metodo para concatenar as colunas do V
	for n in range(vCol.shape[0]):		
		if (np.mean(v) == 0):
			v = vCol[n]
		else:
			v = np.concatenate((v,vCol[n]),axis =1)


	#corrigindo o mesmo erro da matriz u aonde as colunas estavam no lugar das linhas
	v = v.T

	sigma2 = 0

	# mesmo problema da concatenacao com o sigma2
	for n in range(sig2.shape[0]):
		if np.mean(sigma2)==0 :
			sigma2 = sig2[n]
		else:
			sigma2 = np.concatenate((sigma2,sig2[n]),axis =0)


	#print "matriz V"
	#print v

	#agora fazendo a raiz quadrada de sigma2
	sigma = np.sqrt(sigma2)
	identity = np.identity(sigma.shape[0])
	sigma = np.multiply(identity,sigma)


	return u,v,sigma


	


def main():

	#para testar o eig(A)
	#A = [[3,1,1],[1,4,1],[1,1,2]]
	
	choice = input("Digite o modo de operacao, 1 para uma matriz arbritaria, qualquer outro valor para uma matriz escrita no formato do matriz.txt (Altere o txt para alterar a matriz): ")
	if (choice == 1):
		A = [[3,1],[1,4],[1,1]]
	
	else:
		A = np.loadtxt('matriz.txt', delimiter= ',')


	

	#l,v = eig(A)
	'''
	print("Auto Valores")
	print(l)
	print("\n Auto Vetores")
	print(v)
	'''

	u,v,sigma = svd(A)

	print("matriz U")
	print(u)
	print("\nmatriz V_T")
	print(v)
	print("\nSigma")
	print(sigma)
	print("\nMatriz A")
	A = np.array(A)
	print(A)
	print("\nU*Sigma*V_T")
	w = u.dot(sigma.dot(v))
	print(w)

if __name__ == '__main__':
	main()