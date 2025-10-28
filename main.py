#!/usr/bin/env python3

hello = lambda name: print("Hello " + name)

λs = []

for i in range(9):
    λs.append(lambda n: n + i)

print(λs)

for l in λs:
    print(l(0))

# NOTE: This works! Please, what?
# for i, l in enumerate(λs):
#     print(l(0))

# for i, l in enumerate(λs):
#     print("Closure that _should_ return the result of 0 +", i, ": ", l(0))

objs = []

class Closure:
    def call(self, arg):
        raise NotImplementedError

class PlusN(Closure):
    def __init__(self, n): self.n = n
    def call(self, x): return x + self.n

for i in range(9):
    objs.append(PlusN(i))

for o in objs:
    print(o.call(0))

kleines_einmaleins = []

class Mul(Closure):
    def __init__(self, n, k): self.n = n; self.k = k
    def call(self): return self.n * self.k

for i in range(1, 11):
    for j in range(1, 11):
        kleines_einmaleins.append(Mul(i, j))

for res in kleines_einmaleins:
    print(res.call())
