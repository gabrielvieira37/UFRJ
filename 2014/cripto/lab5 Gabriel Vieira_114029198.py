from time import time

#Programa LAB 5

# algoritmo pot
def pot(a,b):
	i=1
	p=a
	while i<b:	
		a*=p
		i+=1
		pass

	return a


#algmoritmo RESTO
def resto (a,b):
	if a<b:
		return a
	else:
		return resto(a-b,b)
	pass

#algoritmo para calcular o quociente
def quociente(dividendo,divisor):
	
	q=0
	resto=dividendo

	while resto>=divisor:
		resto=resto-divisor
		q=q+1
		pass


	return resto

	pass

#algoritmo para calcular o MDC
def mdc(a,b):

	if resto(a,b)==0:
		if (a<b):
			return a	
		else:
			return b		
	else:
	
		return mdc(b, resto(a,b))
	pass


#algoritmo FATORIAL
def fatorial(fator):
	
	indice=fator
	
	if (indice==1):
		return fator
	else:		
		return fator*fatorial(indice-1)
	
	pass




#algoritmo1 Modulo N
def potMod1(b,e,n):
	if (e==0):
		return 1
	else:
		return resto(potMod1(b,e-1,n)*b,n)
#algoritmo2 Modulo N 
def potMod2(b,e,n):
	if (e==0):
		return 1
	else:
		if (e%2==0):
			q = e/2
			return resto(potMod2(b*b,q,n),n)
		else:
			q = e-1/2
			return resto(potMod2(b*b,q,n)*b,n)
#algoritmo de C
def C(n):
	if n==1:
                return 1
        else:
		if (n%2==0):
                        print n/2
			return C(n/2)
		else:
                        print 3*n+1
			return C(3*n+1)

#time
start_time = time()

#QUESTAO 1
#print resto(pot(10,8),17)

#------------------------------

#QUESTAO 2
#print mdc(31,7)

#------------------------------

#QUESTAO 3

#print fatorial(5)

#------------------------------

#QUESTAO 4
#print potMod1(121,12,11)

#QUESTAO5
#print potMod1(2,4,5)

#QUESTAO6
#print potMod1(2,4,5)      

#QUESTAO7
#print C(848641864864165)



print time() - start_time, "seconds"

f = raw_input("/\ this")




























