import numpy as np
import matplotlib.pyplot as plt

def entropy(p,q):
    return (p * np.log(p)) + (q * np.log(q))

N = 10

X = np.linspace(0., 1., num=N)
Y = np.zeros(N)

print X

for i in range(N):
    Y[i] = entropy(X[i], 1. - X[i])
    print i, X[i], 1. - X[i], Y[i]

plt.plot(X)
plt.plot(Y)

plt.show()
