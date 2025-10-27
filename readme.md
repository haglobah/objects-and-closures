
# On Objects and Closures

The accompanying repo to my [_On Closures and Objects_ talk](https://tu-lambda.github.io/#29.10.25)

## Idea

Closures and objects are two sides of the same coin. Both can encapsulate data and behavior:

- **Objects** bundle data (state) with methods (behavior) that operate on that data
- **Closures** capture variables from their lexical scope and return functions that operate on those captured variables

This means you can implement either pattern using the other.

## Direction 1: Objects → Closures

**`main.py`**

Pretty simple: We create a `Closure` class we implement with a `PlusN` class, which we then use as a closure.

## Direction 2: Closures → Objects

**`main.rkt`, `main.ts`**

The reverse direction: how to build object-like behavior using pure closures and message dispatch. They progress through increasingly complex patterns:

1. **Basic message dispatch** - Functions that respond to different messages, simulating method calls
2. **Constructors** - Creating closures with initial state, like object instantiation
3. **Stateful closures** - Capturing and mutating local variables to simulate mutable object state
4. **Static/class variables** - Using outer closures to maintain shared state across multiple instances

(`self`, prototype-based systems everything else (mixins) are possible, too, but skipped here)
