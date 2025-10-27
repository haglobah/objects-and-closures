let hello = (name: string) => console.log(`Hey ${name}`)

let o = (msg: string) => {
  switch (msg) {
    case 'add1':
      return (n: number) => n + 1
    case 'sub1':
      return (n: number) => n - 1
  }
}

console.log(o('add1')!(0)) // 1

let msg = (o: (m: string) => any, m: string, ...a: any[]) => {
  return o(m)(...a)
}

console.log(msg(o, 'add1', 0)) // 1

// Constructors
let constructSymmetric = (x: number) => (msg: string) => {
  switch (msg) {
    case 'add':
      return (n: number) => x + n
    case 'sub':
      return (n: number) => x - n
  }
}

let twelve = constructSymmetric(12)
let ten = constructSymmetric(10)
console.log(msg(twelve, 'add', 4)) // 16
console.log(msg(ten, 'sub', 4)) // 6

// But no state!
console.log(msg(twelve, 'sub', 4)) // 8

// With state
let makeOWithState = (init: number) =>
  ((count) => {
    return (msg: string) => {
      switch (msg) {
        case 'inc':
          return () => {
            count = count + 1
          }
        case 'dec':
          return () => {
            count = count - 1
          }
        case 'get':
          return () => count
      }
    }
  })(init)

let withState = makeOWithState(0)
msg(withState, 'inc')
msg(withState, 'inc')
msg(withState, 'inc')
msg(withState, 'dec')
console.log(msg(withState, 'get')) // 2

// With static
let makeOWithStatic = ((instances) => (amountOrMsg: string | number | null) => {
  if (amountOrMsg === 'instances') {
    return () => instances
  } else {
    instances = instances + 1
    let amount = amountOrMsg as number
    return (msg: string) => {
      switch (msg) {
        case 'inc':
          return (n: number) => {
            amount = amount + n
          }
        case 'dec':
          return (n: number) => {
            amount = amount - n
          }
        case 'get':
          return () => amount
      }
    }
  }
})(0)

console.log(msg(makeOWithStatic, 'instances')) // 1
console.log(msg(makeOWithStatic(1000), 'get'))
console.log(msg(makeOWithStatic, 'instances')) // 2
