---
title: On Objects and Closures
author: "tu-lambda"
theme:
  name: catppuccin-mocha
---

# On Objects and Closures

They're the same thing.

<!-- end_slide -->

# What is an Object?

An object bundles **data** with **behavior** that operates on that data.

```file +exec +line_numbers
path: main.py
language: python
# Only show lines 5-10
start_line: 5
end_line: 10
```

Data: `n`
Behavior: `call` method

<!-- end_slide -->

# What is a Closure?

A closure captures **variables** from its lexical scope and returns **functions** that operate on those variables.

```python
for i in range(9):
    λs.append(lambda n: n + i)
```

Captured variable: `i`
Returned function: the lambda

<!-- end_slide -->

# They Do the Same Thing

```python
# Object version
obj = PlusN(5)
obj.call(10)  # 15

# Closure version
λs = []
for i in range(9):
    λs.append(lambda n: n + i)
λs[5](10)  # 15
```

Same input, same output. Different implementation.

<!-- end_slide -->

# Direction 1: Objects → Closures

We can replace objects with closures:

```python
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
    print(o.call(0))  # 0, 1, 2, ..., 8
```

becomes:

```python
λs = []

for i in range(9):
    λs.append(lambda n: n + i)

for l in λs:
    print(l(0))  # 0, 1, 2, ..., 8
```

Objects are just a structured way of organizing closures.

<!-- end_slide -->

# Direction 2: Closures → Objects

We can also build object-like behavior using pure closures.

The key: **message dispatch**

```racket
(define o
  (λ (msg)
    (case msg
      [(add1) (λ (n) (+ n 1))]
      [(sub1) (λ (n) (- n 1))])))

((o 'add1) 0)  ; 1
```

A function that takes a message and returns another function. That's a method call.

<!-- end_slide -->

# Building Constructors

We can create closures with initial state:

```racket
(define (construct-symmetric x)
  (λ (msg)
    (case msg
      [(add) (λ (n) (+ x n))]
      [(sub) (λ (n) (- x n))])))

(define twelve (construct-symmetric 12))
((twelve 'add) 4)  ; 16
```

The closure captures `x`. Just like an object stores data in fields.

<!-- end_slide -->

# Adding Mutable State

Closures can mutate their captured variables:

```racket
(define (make-o-with-state init)
  (let ([count init])
    (λ (msg)
      (case msg
        [(inc) (λ () (set! count (+ count 1)))]
        [(dec) (λ () (set! count (- count 1)))]
        [(get) (λ () count)]))))

(define with-state (make-o-with-state 0))
((with-state 'inc))
((with-state 'inc))
((with-state 'inc))
((with-state 'dec))
((with-state 'get))  ; 2
```

The closure maintains state across calls. Just like an object.

<!-- end_slide -->

# Shared State Across Instances

We can even implement class variables using outer closures:

```racket
(define make-o-with-static
  (let ([instances 0])
    (λ (amount-or-msg)
      (case amount-or-msg
        [(instances) (λ () instances)]
        [else
         (begin
           (set! instances (+ 1 instances))
           (λ (msg)
             (case msg
               [(inc) (λ (n) (set! amount-or-msg (+ amount-or-msg n)))]
               [(dec) (λ (n) (set! amount-or-msg (- amount-or-msg n)))]
               [(get) (λ () amount-or-msg)])))]))))
```

The outer `let` creates shared state. Every instance increments the same counter.

<!-- end_slide -->

# They're Equivalent

| Feature | Objects | Closures |
|---------|---------|----------|
| Data | Fields | Captured variables |
| Behavior | Methods | Returned functions |
| Instantiation | Constructor | Factory function |
| Mutable state | `this.x = ...` | `set!` on captured vars |
| Class variables | `static` | Outer closure scope |

<!-- end_slide -->

# Why This Matters

Understanding this equivalence helps you:

- **See past syntax** - Different languages, same concepts
- **Translate between paradigms** - Functional ↔ Object-oriented
- **Choose the right tool** - Pick what's clearest for your problem
- **Understand your language** - Know what's really happening under the hood

<!-- end_slide -->

# The Takeaway

Closures and objects are two sides of the same coin.

You can implement either pattern using the other.

They're computationally equivalent.

<!-- end_slide -->
