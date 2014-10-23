{can_generalize, pattern2str} = require './syntax'

isBR = (pat) ->
  return true if pat.length is 6 and pat[0].str is '<' and pat[1].var?  and pat[2].str is 'b' and pat[3].var?  and pat[4].str is 'r' and pat[5].var?
  return true if pat.length is 7 and pat[1].str is '<' and pat[2].var?  and pat[3].str is 'b' and pat[4].var?  and pat[5].str is 'r' and pat[6].var?
  return false

add = (x, y) -> x + y
sum = (ls) -> ls.reduce add

classify = (patterns, doc) ->
  N = patterns.length
  scores = for i in [0 ... N]
    sum (for p in patterns[i]
      sum (for d in doc
        if can_generalize p, d then 1 else 0))

  cx = 0
  for i in [0 ... N]
    for p in patterns[i]
      if not (isBR p)
        continue
      for d in doc
        if can_generalize p, d then ++cx
  console.warn 'br number is ', cx

  mxi = -1
  mxx = -1
  for i in [0 ... N]
    if mxx < scores[i]
      mxx = scores[i]
      mxi = i

  mxi

module.exports = classify
