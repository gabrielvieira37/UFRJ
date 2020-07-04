import numpy as np

#length of pages

T = 4 

betha = 0.8

#adjacency matrix , for general purposes shape = TxT where T is the number of pages

adjMatrix = [[0.0,0.5,0.5,0.0],
			[0.0,0.0,1.0,0.0],
			[1.0,0.0,0.0,0.0],
			[0.0,0.0,1.0,0.0]]


adjMatrix = betha * np.array(adjMatrix)

adjshape = adjMatrix.shape

print(adjshape)


randomMatrix = np.ones(adjshape)

randomMatrix = ((1-betha)/T) * randomMatrix

#Random Teleport with the probabilty to go to other page
probMatrix = randomMatrix + adjMatrix

threshold =  0.0001

#Initial guess for vector

v = np.array([1.0,1.0,1.0,1.0])

count = 0

#Iterative method trying to converge to optimal solution
diff=1
while(diff > threshold):
    print(v)
    vtemp = np.copy(v)
    v = np.dot(v,probMatrix)
    diff = np.square(v - vtemp)
    diff = np.sum(diff)
    print("diff: {0:.7f}".format(diff))
