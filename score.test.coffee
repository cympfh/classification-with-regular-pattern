score = require './score'

d = 'test'
Pi = [
  [{str: 'test'}]
  [{var: 0}]
  [{str: 'te'}, {var: 1}]
]

TP = ['teddy', 'fish']
TQ = ['toast', 'gosh']

console.warn score d, Pi, TP, TQ, true
console.warn score d, Pi, TP, TQ, true

