from math import sqrt

def mdcExtd(a,b):
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
	print(r1)
	print("")
	print(x1)
	print("")
	print(y)


def parteImpar(n):
	q=n
	e=0
	qtemp=q
	while (qtemp%2==0):
		qtemp=qtemp/2
		e=e+1
	return qtemp,e

def Fermat(n):
	n1=parteImpar(n)
	
	d=0
	while sqrt(d*d+4*n1[0]) != int(sqrt(d*d+4*n1[0])):
		d=d+2
	s=sqrt(d*d+4*n1[0])
	a=(d-s)/2
	b=(d+s)/2
	print(a)
	print("")
	print(b)
	if (a-b == n1[0]-1):
		print(n)
		print(" è primo")
	return 2,n1[1],a,b

def FatComp(n):
	i=2
	while (n>1):
		if (n%i==0):
			n=(n/i)
			a=i
		else:
			i=i+1
	return a

