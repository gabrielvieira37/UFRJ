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

#   N: # of samples
#   C: # of features
#   X: N X C (+ 1) -> bias trick
#   y: N X 1
#   w: 1 X C (+ 1) -> bias trick

class PerceptronSGD:
    def __init__(self, eta=1.0):
        # self.tol = tol
        self.eta = eta

    def fit(self, X, y, epochs, batch_size):
        X, y = np.array(X), np.array(y)
        samples, features = X.shape[0], X.shape[1]
        self.w = np.random.uniform(-0.1, 0.1, (1, features))
        self.b = np.random.uniform(-0.1, 0.1, (1,1))
        epoch = 0
        while epoch < epochs:
            loss = 0
            nabla_w = 0.0
            derron_b = 0.0
            idx = np.random.randint(samples, size=batch_size)
            for i in idx:
                y_hat = np.tanh(np.dot(X[i], self.w.T)+self.b)
                loss += np.square(y[i] - y_hat[0][0])
                nabla_w += -2*X[i]*np.square(1.0/np.cosh(np.dot(X[i], self.w.T)+self.b))*(y[i]-y_hat)
                derron_b += -2*np.square(1.0/np.cosh(np.dot(X[i], self.w.T)+self.b))*(y[i]-y_hat)
            self.w -= (self.eta/batch_size) * nabla_w
            self.b -= (self.eta/batch_size) * derron_b
            print ('epoch loss: %f' % (loss/batch_size))
            epoch += 1

    def predict(self, X):
        y = np.tanh(np.dot(X, self.w.T) + self.b)
        y = [-1.0 if sample < 0.0 else 1.0 for sample in y]
        return y

data = generate_linear_data(np.array([1,2,3]), 0, 100000)
net = PerceptronSGD()
net.fit(data[0], data[1], 200, 128)
test_data = generate_linear_data(np.array([1,2,3]), 0, 2000)
y_hat = net.predict(test_data[0])
print (np.mean(np.equal(y_hat, test_data[1])))
print ('w: ' + str(net.w))
print ('b: '+ str(net.b))
# plot_points_and_plane(net, data[0], data[1])
