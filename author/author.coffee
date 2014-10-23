read = require '../read'
pattern_classify = require '../index'

# docs
joseito = read './doc/joseito.txt'
dasgemeine = read './doc/dasgemeine.txt'
viyon = read './doc/viyon.txt'

arashi = read './doc/arashi.txt'
asameshi = read './doc/asameshi.txt'
shokudo = read './doc/shokudo.txt'

console.warn "stat"
console.warn [joseito, dasgemeine, viyon].map (ls) -> ls.length
console.warn [arashi, asameshi, shokudo].map (ls) -> ls.length

# training

TP = joseito
TQ = arashi

TP = TP[0 ... 400]
TQ = TQ[0 ... 400]

# test

test = (U, answer) ->

  {P:P, N:N, Q:Q} = pattern_classify TP, TQ, U
  predict = if P > Q then 'P' else 'Q'

  console.log "| #{[P,N, Q, predict].join ' | '} |"

test joseito, 'P'
test dasgemeine, 'P'
test viyon, 'P'

test arashi, 'Q'
test asameshi, 'Q'
test shokudo, 'Q'
