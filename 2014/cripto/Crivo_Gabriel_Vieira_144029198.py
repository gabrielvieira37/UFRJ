def ListaImpar(n):
	Listimpar = []

	#aqui � aonde a lista de numeros impares � feita 

	for i in range(3,n+1,2):
		
		Listimpar.append(i)

	return Listimpar


def Crivo(n):
	Listimpar = []
	ListPrim = []
	k=0

	Listimpar = ListaImpar(n)

	#aqui � aonde os n�meros primos s�o achados, a cada posi��o S ele soma
	#com o valor armazenado na lista L[s] o que gera um indice K = L[s]+s com esse  
	#indice voc� percebe L[k] � um multiplo de L[s] ent�o, L[k] recebe 0 pois n�o �  primo.

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
	
	Print(" Os numeros primos at� esse numero s�o: ")
	
	for i in Range(len(List)):
		Print(List[i])