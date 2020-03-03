Python 3.2.1 (default, Jul 10 2011, 21:51:15) [MSC v.1500 32 bit (Intel)] on win32
Type "copyright", "credits" or "license()" for more information.
>>> def e(a1,v,a):
	x = (a1*v)+a
	return x
def n(a1,b2,v,a,b):
	
SyntaxError: invalid syntax
>>> e(2,3,4)
Traceback (most recent call last):
  File "<pyshell#4>", line 1, in <module>
    e(2,3,4)
NameError: name 'e' is not defined
>>> def e (a1,v,a):
	x=(a1*v)+a
	return x

>>> e(1,2,3)
5
>>> def n(a1,b2,a,b,v):
	x=(a1*b2*v)+(a*b2)+(a1*b)+1
	return x

>>> def v(a,b):
	x=(a*b)-1
	return x

>>> def d(b2,v,b):
	x=(b2*v)+b
	return x

>>> a=10
>>> b=35
>>> a1=40
>>> b2=55
>>> v=v(a,b)
>>> print v
SyntaxError: invalid syntax
>>> v(a,b)
Traceback (most recent call last):
  File "<pyshell#28>", line 1, in <module>
    v(a,b)
TypeError: 'int' object is not callable
>>> print "b"
SyntaxError: invalid syntax
>>> print b
SyntaxError: invalid syntax
>>> print a
SyntaxError: invalid syntax
>>> a
10
>>> b
35
>>> v
349
>>> e(a1,v,a)
13970
>>> e
<function e at 0x00FA7348>
>>> e
<function e at 0x00FA7348>
>>> e=e(a1,v,a)
>>> e
13970
>>> e
13970
>>> n=n(a1,b2,v,a,b)
>>> n
96596
>>> 
>>> 
>>> n
96596
>>> n
96596
>>> 
>>> 
>>> 
>>> 
>>> 
>>> 
>>> n
96596
>>> def resto1(m,e,n):
	x=(m*e)%n
	return x

>>> def resto2(c,d,n):
	x=(c*d)%n
	return x

>>> e
13970
>>> n
96596
>>> d
<function d at 0x00FA73D8>
>>> d=d(b2,v,b)
>>> d
19230
>>> m=1001
>>> m
1001
>>> c=resto1(m,e,n)
>>> c
74146
>>> resto2(c,d,n)
70620
>>> (c*d)%n
70620
>>> x
Traceback (most recent call last):
  File "<pyshell#73>", line 1, in <module>
    x
NameError: name 'x' is not defined
>>> d
19230
>>> c*d
1425827580
>>> n
96596
>>> c*d/n
14760.73108617334
>>> a
10
>>> b
>>> b
35
>>> v
349
>>> a1
40
>>> 40*349
13960
>>> 13960+10
13970
>>> e
13970
>>> a1
40
>>> b2
55
>>> 40*55*349
767800
>>> 10*55
550
>>> 40*35
1400
>>> 767800+550+1400+1
769751
>>> n
96596
>>> a=2300
>>> b=4000
>>> a1=5000
>>> b2=6000
>>> v=v(a*b)-1
Traceback (most recent call last):
  File "<pyshell#97>", line 1, in <module>
    v=v(a*b)-1
TypeError: 'int' object is not callable
>>> 
>>> v=v(a,b)
Traceback (most recent call last):
  File "<pyshell#99>", line 1, in <module>
    v=v(a,b)
TypeError: 'int' object is not callable
>>> v
349
>>> v
349
>>> v(a,b)
Traceback (most recent call last):
  File "<pyshell#102>", line 1, in <module>
    v(a,b)
TypeError: 'int' object is not callable
>>> v =(a*b)-1
>>> v
9199999
>>> e
13970
>>> e
13970
>>> def e(a1,v,a):
	x=(a1*v)+a
	return x
e
SyntaxError: invalid syntax
>>> def e(a1,v,a):
	x=(a1*v)+a
	return x

>>> e(a1,v,a)
45999997300
>>> def n(a1,b2,v,a,b):
	x=(a1*b2*v)+(a*b2)+(a1*b)+1
	return x

>>> def d(b2,v,b):
	x=(b2*v)+b
	return x

>>> 
>>> m=88008800
>>> c=resto1(m,e(a1,v,a),n(a1,b2,v,a,b))
>>> c
36506637825332
>>> resto2(c,d(b2,v,b),n(a1,b2,v,a,b))
88008800
>>> 
