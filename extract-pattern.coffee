###
# k: iteration  times
# m: threshold (must > EP.length / (EP.length + EQ.length))
# EP: array of documents with class P
# EQ: array of documents with class Q
###

mcp = require './mcp'
{can_generalize, pattern2str} = require './syntax'

random_select = (list) ->
  I = list.length

  if I is 0
    return false

  idx = (do Math.random) * I | 0
  list[idx]

extract_pattern = (k, m, EP, EQ, debug = false) ->

  Pi = [] # return value

  if m is null
    m = EP.length / (EP.length + EQ.length) * 1.1

  rec = (k) ->

    return Pi if k < 0

    e1 = random_select EP
    e2 = random_select EP

    return rec k if e1 is e2

    p = mcp e1, e2

    goodness =
      EP.filter (e) -> can_generalize p, e
        .length

    badness =
      EQ.filter (e) -> can_generalize p, e
        .length

    score = (goodness / (goodness + badness))

    if debug
      console.warn "pattern", pattern2str p
      console.warn "goodness, badness, push?", goodness, badness, (score > m)
      console.warn ''

    if score >= m
      Pi.push p
      EP = EP.filter (e) ->
        not can_generalize p, e

    return rec k - 1

  rec k

module.exports = extract_pattern
