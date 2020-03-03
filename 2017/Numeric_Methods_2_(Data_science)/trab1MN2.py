#DRE 114029198
#Nome : Gabriel dos Santos Vieira
import numpy as np
import matplotlib.pyplot as plt

def main():

	# teste 
	Cidades = np.matrix([0,2,3,5,7,11,13,15,20])
	CidadesNorm = np.linalg.norm(Cidades)
	pontos = Cidades/CidadesNorm
	Ones = np.ones(Cidades.shape)
	Distancias = np.matmul(Cidades.T,Ones)
	Distancias = Distancias - Distancias.T
	Distancias = np.square(Distancias)





	#Distancias sera carregada pelos dados do problema

	Distancias = np.loadtxt('dados.txt', delimiter= ',')
	print "Matriz das Distancias:"
	print Distancias
	print ""


	DistanciasNorm = np.linalg.norm(Distancias)

	Distancias = Distancias/DistanciasNorm
	print "Distancias Normalizadas: "
	print Distancias
	avg = np.mean(Distancias)
	
	num = avg**0.5

	#cria um chute para os pontos das cidades com a media dos valores da matriz 
	Cidades_Chute = np.random.rand(1,9) 
	Cidades_Chute[0,0] = 0
	Ones = np.ones(Cidades_Chute.shape)

	#

	tol = 1
	learnRate = 0.001
	print ""
	while(tol>0.0012):
		Distancias_Chute = np.matmul(Cidades_Chute.T,Ones)
		Distancias_Chute = Distancias_Chute - Distancias_Chute.T
		Distancias_Chute2 = np.square(Distancias_Chute)

		Grad = np.zeros(Cidades_Chute.shape)

		for i in range(1,Cidades_Chute.shape[1]):
			for j in range(Cidades_Chute.shape[1]):
				
				if i != j:
					#Gradiente Descendente
					Grad[0,i] +=  4 * (Distancias_Chute2[i,j]- Distancias[i,j])*Distancias_Chute[i,j]

		Cidades_Chute -= learnRate * Grad


		Distancias_Chute = np.matmul(Cidades_Chute.T,Ones)
		Distancias_Chute = Distancias_Chute - Distancias_Chute.T
		Distancias_Chute2 = np.square(Distancias_Chute)


		erro = np.square(Distancias - Distancias_Chute2)

		erro2 = np.mean(erro)
		print "erro: "
		print erro2
		tol = erro2

	print "Pontos normalizados com tolerancia de 10^-3: "
	print Cidades_Chute
	

	plt.plot(Cidades_Chute,[0.0]*len(Cidades_Chute),'ro')
	plt.show()


	#origem = Cidades_Chute[0,0]
	#print origem
	#ide = np.ones(Cidades_Chute.shape)
	#ide = ide * origem
	#Cidades_Chute = Cidades_Chute - ide
	#print Cidades_Chute
	#print Cidades_Chute* DistanciasNorm
	#print Grad
	#print Grad[0,2]
	



	


if __name__ == '__main__':
	main()