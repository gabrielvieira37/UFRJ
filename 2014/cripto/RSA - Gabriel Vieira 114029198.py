def mdc(a,b):
    R1=a
    R2=b
    while R2 != 0:
          Rtemp = R2
          R2 = R1 % R2
          R1 = Rtemp
    return(R1)



def Inverso(a,b):
	q=a/b
	x1=1
	x2=0
	xtemp=0
	r1=a
	r2=b
	r=a-b*q
	while r>0:
		qtemp=r1/r2
		xtemp=x1-x2*qtemp
		x1=x2
		x2=xtemp
		r = r1-r2*qtemp
		r1 = r2
		r2 = r
	y=(r1-x1*a)/b
	while x1 < 0:
		x1=x1+b
	return x1



def geraChavesRSA(p,q):
	n = p*q
	t = (p-1)*(q-1)
	e = 3
	while mdc(t,e) != 1:
		e = e+1
	d=Inverso(e,t)
	publica = [n,e]
	privada = [n,d]
	return publica,privada


def RSA(Chave,L):
	tamanho = length(L)
	i=0
	while i < tamanho:
		L[i] = pow(L[i],Chave[1],Chave[0])
		i=i+1
	return L



def precode(n,M):
	t=0
	for i in range(0,len(M)):
		t=t+ord(M[i])*pow(100,i)
	k=int(math.log10(n))
	L=[]
	while (t>0):
		q=t/pow(10,k)
		L.append(t%pow(10,k))
		t=q
	return L

def unprecode(n,L):
	k=int(math.log10(n))
	S=[]
	t=0
	b=pow(10,k)
	for i in range(0,len(L)):
		t=t+L[i]*pow(b,i)
	print t
	while (t>0):
		q=t/100
		S.append(chr(t%100))
		t=q
	return S

