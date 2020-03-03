#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""

Alunos: 
Mateus Ildefonso do Nascimento - 114073032
Gabriel dos Santos Vieira -114029198
Victor Garritano Noronha - 114023388

"""


import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np

def generate_linear_data(w,b,n):
    dim = len(w)
    y = []
    X = []
    for i in xrange(n):
        x = np.random.uniform(-10,10,dim)
        if(np.dot(w,x) + b > 5):
            y.append(1)
            X.append(x)
        elif(np.dot(w,x) + b < -5):
            y.append(-1)
            X.append(x)
    return np.array(X),y

def plot_points(X,y):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    X1 = []
    X2 = []
    for i in xrange(len(y)):
        if (y[i] == -1):
            X1.append(X[i])
        else:
            X2.append(X[i])
    X1 = np.array(X1)
    X2 = np.array(X2)
    ax.scatter(X1[:,0], X1[:,1], X1[:,2], c='blue', marker='^')
    ax.scatter(X2[:,0], X2[:,1], X2[:,2], c='red', marker='o')
    plt.show()

def plot_points_and_plane(net,X,y):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    X1 = []
    X2 = []
    for i in xrange(len(y)):
        if (y[i] == -1):
            X1.append(X[i])
        else:
            X2.append(X[i])
    X1 = np.array(X1)
    X2 = np.array(X2)
    ax.scatter(X1[:,0], X1[:,1], X1[:,2], c='blue', marker='^')
    ax.scatter(X2[:,0], X2[:,1], X2[:,2], c='red', marker='o')
    bias = net.b
    xx, yy = np.meshgrid(np.linspace(np.min(X)-1.0, np.max(X)+1.0, 10), np.linspace(np.min(X)-1.0, np.max(X)+1.0, 10))
    z = (-net.w[0][0] * xx - net.w[0][1] * yy - bias) * 1. / net.w[0][2]
    ax.plot_surface(xx, yy, z, alpha=0.3, rstride=1, cstride=1,
                        color='green', linewidth=0, 
                        antialiased=True, shade=False)
    plt.show()

class Perceptron:
    def __init__(self, tol, eta):
        self.tol = tol
        '''
        fit roda até que a 
        variação do erro 
        entre duas iterações seja 
        menor que esse valor
        '''
        self.w = None
        self.b = None
        self.eta = eta #learning rate
        
    def fit(self, X, y):
        #fit não deve possuir retorno.
        '''
        crie aqui os atributos w e b, de tal
        forma que você possa recuperá-los depois
        para plotar.
        '''
        samples, features = X.shape
        self.w = np.random.uniform(-0.1,0.1,(1,features))
        self.b = np.random.uniform(-0.1,0.1)

        loss = 1000
        while((loss/samples) > self.tol):
            delta_w, delta_b = 0.0, 0.0
            loss = 0
            for i in range(samples):
                y_hat = np.tanh(np.dot(X[i],self.w.T)+self.b)
                loss += np.square(y[i] - y_hat)
                delta_w += -2*X[i]*np.square((1.0/np.cosh(np.dot(X[i],self.w.T)+self.b))) * (y[i] - y_hat)
                delta_b += -2*np.square((1.0/np.cosh(np.dot(X[i],self.w.T)+self.b))) * (y[i] - y_hat)
            self.w = self.w - (self.eta/samples) * delta_w
            self.b = self.b - (self.eta/samples) * delta_b
            print (loss/samples)


    def predict(self, X):
        y = np.tanh(np.dot(X,self.w.T)+self.b)
        y = [-1.0 if sample < 0.0 else 1.0 for sample in y]
        return y
        #predict deve retornar as classes para X
data = generate_linear_data(np.array([1,2,3]), 0, 1000)
net = Perceptron(10e-5, 0.5)
net.fit(data[0], data[1])
test_data = generate_linear_data(np.array([1,2,3]), 0, 200)
y_hat = net.predict(test_data[0])
print ('Test accuracy: ' + str(np.mean(np.equal(y_hat, test_data[1]))))
print ('w: ' + str(net.w))
print ('b: '+ str(net.b))
plot_points_and_plane(net, data[0], data[1])
