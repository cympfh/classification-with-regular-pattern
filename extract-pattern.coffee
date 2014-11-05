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
{can_generalize, pattern2str, noteq} = require './syntax'

random_select = (list) ->
  I = list.length
  return false if I is 0
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

extract_pattern = (docs, options) ->

  N = docs.length
  lens = for d in docs
    d.length
  sum_lens = lens.reduce add

  pis = for i in [0 ... N]
    []

  # mutual information threshold
  m = options?.threshold ? 0

  iterate = options?.iterate ? 100

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

        mi0 = pmatchy * Math.log (pmatchy / pmatch / py)
        mi1 = pnoty * Math.log (pnoty / pnot / py)

        mi0 + mi1)

      if MI > m
        j = max_index matches
        pis[j].push
          pattern: p
          mi: MI

  # filter better patterns from pis
  for i in [0 ... N]
    pis[i].sort (a, b) -> - a.mi + b.mi

  M = Math.min.apply null, (pis.map (r) -> r.length)

  sets = for i in [0 ... N]
    ls = []
    last = []
    idx = 0
    #while ls.length < M and idx < pis[i].length
    while idx < pis[i].length
      if noteq pis[i][idx].pattern, last
        last = pis[i][idx].pattern
        ls.push pis[i][idx]
        #console.warn pis[i][idx].mi, (pattern2str pis[i][idx].pattern)
      ++idx
    ls

  sets

module.exports = extract_pattern
