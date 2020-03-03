import time

def resto(a,b):
	r=a
	while r>=b:
		r=r-b
	return(r)



t1 = time.time()
		
a=resto(12345678,2)

t2 = time.time()


dT=t2-t1

print(dT)


t3 = time.time()		
a=12345678%2
t4 = time.time()


dT2=t3-t4

print(dT2)






def quociente(a,b):
	q=0
	while a>=b:
		a=a-b
		q=q+1
	return(q)

def euclides(a,b):
	r1=a
	r2=b
	qtdDiv=0
	
	
	if (r2==0):
                print(qtdDiv)
		return r1
		
	if (r2>0):
                r1=r2
                r2=a-b*quociente(a,b)
                qtdDiv=qtdDiv+1
		euclides(r1,r2)

def parteImpar(n)
	q=n
	e=0
	while (q%2==0):
		q=q/2
		e=e+1
	print(e)
	print(q)

def sequenciaLucas(n)
	S=4
	while (n>0):
		print(s)
		s1=(s*s)-n
		s=s1
		n=n-1

def mdc3 (a,b,c)
	
	ValA = euclides(a,b)
	return euclides(ValA,c)

		
	