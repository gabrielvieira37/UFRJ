import numpy as np 

x = np.array([[0,0,1],[0,1,1],[1,0,1],[1,1,1]])
y = np.array([[0],[1],[1],[0]])
w1 = np.random.normal(size=(3,5))
w2 = np.random.normal(size=(5,1))

def sigmoid(x):
	return 1.0 / (1.0 + np.exp(-x))

def sigmoid_prime(x):
	return x*(1.0 - x)

for epoch in range(60000):
	h = x.dot(w1)
	h_activated = sigmoid(h)
	y_ball = h_activated.dot(w2)
	y_hat = sigmoid(y_ball)

	loss = np.mean(0.5 * np.square(y - y_hat))
	if epoch % 1000 == 0:
		print ('epoch: {}	loss: {}'.format(str(epoch), str(loss)))

	l2_loss = -(y - y_hat)
	l2_delta = l2_loss * sigmoid_prime(y_hat)
	grad_w2 = h_activated.T.dot(l2_delta)
	l1_error = l2_delta.dot(w2.T)
	l1_delta = l1_error * sigmoid_prime(h_activated)
	grad_w1 = x.T.dot(l1_delta)

	w1 -= grad_w1
	w2 -= grad_w2

print y_hat
