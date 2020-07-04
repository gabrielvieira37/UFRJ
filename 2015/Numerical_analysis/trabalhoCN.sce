clc()
n = input("digite o numero de partições: ")
x=linspace(0,1,n)
deltaX = 1/n
y= (%e^x)
tol = 10^(-5)
eabs = 0
erel =0
iRec = 0
iTrap = 0

for i=0:1:n-1
    
    iRec = ((%e^(deltaX*i)^2)*deltaX) + iRec
    
end

iTrap = (%e^(deltaX^2) + %e^((deltaX*(n+1))^2))/2

for i=0:1:n-1
    
    iTrap = (%e^(deltaX*(i+1))^2) + iTrap   
    
end

iTrap = iTrap * deltaX


eabs = iTrap-iRec
erel = iTrap-iRec/iTrap





while eabs > (10^-5)

    eabs = 0
    erel =0
    iRec = 0
    iTrap = 0
    deltaX = 1/n
    
for i=0:1:n-1
    
    iRec = ((%e^(deltaX*i)^2)*deltaX) + iRec
    
end

iTrap = (%e^(deltaX^2) + %e^((deltaX*(n+1))^2))/2

for i=0:1:n-1
    
    iTrap = (%e^(deltaX*(i+1))^2) + iTrap   
    
end

iTrap = iTrap * deltaX


eabs = iTrap-iRec
erel = iTrap-iRec/iTrap

n = n*2

end

mprintf("A integral numerica pelo metodo do retangulo é igual a: %.10f \n", iRec)

mprintf("A integral numerica pelo metodo do trapezio é igual a: %.10f \n", iTrap)

mprintf("O erro absoluto entre as duas integrais é igual a: %.10f \n", eabs)

mprintf("O erro relativo entre as duas integrais é igual a: %.10f \n", erel)

mprintf("O o numero de partições para que erro relativo entre as duas integrais seja menor ou igual a 10 elevado a -5 é igual a: %d \n", n)
//plot(x,y)

