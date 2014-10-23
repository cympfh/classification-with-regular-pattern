{can_generalize, pattern2str} = require './syntax'

add = (x, y) -> x + y
sum = (ls) ->
  if ls.length is 0
    0
  else
    ls.reduce add

classify = (patterns, doc) ->
  N = patterns.length
  scores = for i in [0 ... N]
    sum (for p in patterns[i]
      sum (for d in doc
        if can_generalize p, d then 1 else 0))

  mxi = -1
  mxx = -1
  for i in [0 ... N]
    if mxx < scores[i]
      mxx = scores[i]
      mxi = i

  mxi

module.exports = classify
