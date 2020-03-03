def ListaImpar(n):
	Listimpar = []

	#aqui é aonde a lista de numeros impares é feita 

	for i in range(3,n+1,2):
		
		Listimpar.append(i)

	return Listimpar


def Crivo(n):
	Listimpar = []
	ListPrim = []
	k=0

	Listimpar = ListaImpar(n)

	#aqui é aonde os números primos são achados, a cada posição S ele soma
	#com o valor armazenado na lista L[s] o que gera um indice K = L[s]+s com esse  
	#indice você percebe L[k] é um multiplo de L[s] então, L[k] recebe 0 pois não é  primo.

	for s in range(n/2):
	
		if (Listimpar[s] > 0) :
		
			k =  Listimpar[s] + s
		
			Listimpar[k] = 0
		
			ListPrim.append(Listimpar[s])
	
	return ListPrim


def eratostenes():
	
	n=input("Entre com um numero: ")
	
	List = []
	List = Crivo(n)
	
	Print(" Os numeros primos até esse numero são: ")
	
	for i in Range(len(List)):
		Print(List[i])