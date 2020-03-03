#!/usr/bin/env python
# -*- coding: utf-8 -*-

import numpy as np
class RedeNeural:
    def __init__(self, eta, numrounds, hidden_nodes):
        self.numrounds = numrounds
        '''
        fit roda até que numrounds
        seja alcançado
        '''
        
        self.eta = eta #learning rate
        self.hidden_nodes = hidden_nodes
        '''
        Quantidade de nós no hidden layer
        '''

    #Inicializa os vetores com a gaussian mean zero, esta distribuição
    #garante uma melhor convergência
    def generateWeights(self, inputSize, outputSize):
        Ws = list()
        previousSize = inputSize
        for currentSize in self.hidden_nodes:
            Ws.append(np.random.normal(size=(previousSize,currentSize)))
            previousSize = currentSize
        Ws.append(np.random.uniform(size=(previousSize,outputSize)))
        return Ws    

    def sigmoid(self, x):
        return 1.0 / (1.0 + np.exp(-x))

    def sigmoid_prime(self, x):
        return x*(1.0 - x)

    def fit(self, X, y):
        (samples, features) = X.shape
        X = np.c_[X, np.ones((samples,1))]
        self.Ws = self.generateWeights(features+1,y.shape[1])
        epoch = 0
        while epoch < self.numrounds:
            #feed forward
            h = X
            hs = list()
            hs.append(X)
            
            for w in self.Ws:
                y_ball = h.dot(w)
                y_hat = self.sigmoid(y_ball)
                h = y_hat
                hs.append(y_hat)
            #backward pass            
            loss = np.mean(0.5*np.square(y-y_hat))
            deltas = list()
            
            error = -(y - y_hat)
            for i in xrange(1,len(hs)):
                deltas.append(error*self.sigmoid_prime(hs[-i]))
                error = deltas[-1].dot(self.Ws[-i].T)
                #Atualiza
                self.Ws[-i] -= hs[-i-1].T.dot(deltas[-1])*(self.eta*1.0)

            if epoch%1000 == 0:
                print('epoch: {}    loss: {}'.format(str(epoch), str(loss)))

            epoch += 1
        print hs[-1]
        
    def predict(self, X):
        pass
        #predict deve retornar as classes para X


#input data
X = np.array([[0,0],  # Note: there is a typo on this line in the video
            [0,1],
            [1,0],
            [1,1]])


# The output of the exclusive OR function follows. 

#output data
y = np.array([[0],
             [1],
             [1],
             [0]])

RN = RedeNeural(1,60000,[4])
RN.fit(X,y)