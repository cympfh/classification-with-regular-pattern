###
#
# extract :: docs -> pattern_sets
#
# doc :: [sentences]
# docs :: [doc]
# pattern_set :: [pattern]
# pattern_sets :: [pattern_set]
#
# docs.length === pattern_sets.length
#
# docs[i] is class-i document
# pattern_sets[i] is the set of patterns for class-i
#
###

mcp = require './mcp'
{can_generalize, pattern2str} = require './syntax'

random_select = (list) ->
  I = list.length

  if I is 0
    return false

  idx = (do Math.random) * I | 0
  list[idx]

add = (x, y) -> x + y
sum = (ls) -> ls.reduce add

max_index = (ls) ->
  mx = ls[0]
  mi = 0
  for i in [1 ... ls.length]
    if mx < ls[i]
      mx = ls[i]
      mi = i
  mi

extract_pattern = (docs, debug = false) ->

  N = docs.length
  lens = for d in docs
    d.length
  sum_lens = lens.reduce add

  ranks = for i in [0 ... N]
    []

  # mutual information threshold
  #m = EP.length / (EP.length + EQ.length) * 1.1

  iterate = 1000

  for k in [0 ... iterate]

    for i in [0 ... N]
      d = docs[i]

      e1 = random_select d
      e2 = random_select d
      p = mcp e1, e2

      if p.length is 1 and p[0].var?
        continue

      matches = for j in [0 ... N]
        docs[j].filter (d) -> can_generalize p, d
          .length

      sum_matches = matches.reduce add

      MI = sum (for j in [0 ... N]
        pmatchy = matches[j] / sum_lens
        pmatch = sum_matches / sum_lens
        py = lens[j] / sum_lens
        pnoty = (lens[j] - matches[j]) / sum_lens
        pnot = 1 - pmatch
        pmatchy * Math.log (pmatchy / pmatch / py) + pnoty * Math.log (pnoty / pnot / py))

      if MI > 0
        j = max_index matches
        ranks[j].push
          pattern: p
          mi: MI

  # filter better patterns from ranks
  sets = []
  for i in [0 ... N]
    ranks[i].sort (a, b) -> - a.mi + b.mi
    sets[i] = for j in [0 ... iterate/100]
      #console.warn pattern2str ranks[i][j].pattern
      ranks[i][j].pattern

  sets

module.exports = extract_pattern
