{new_var, sub_str} = require './syntax'

merge = (pat) ->
  ret = [pat[0]]
  last = pat[0]
  for i in [1 ... pat.length]
    if pat[i].str? and last.str?
      ret[ret.length - 1].str += pat[i].str
    else if pat[i].var? and last.var?
      # pass
    else
      ret.push pat[i]

    last = pat[i]

  ret

module.exports = (s, t) ->
  S = s.length
  T = t.length

  table = for i in [0 .. S]
    for j in [0 .. T]
      len: 0
      pat: []

  for i in [0 ... S]
    for j in [0 ... T]
      # update table[i+1][j+1]
      l0 = if s[i] is t[j] then table[i][j].len + 1 else 0
      l1 = table[i+1][j].len
      l2 = table[i][j+1].len

      table[i+1][j+1] =
        if l0 > l1 and l0 > l2
          len: l0
          pat: table[i][j].pat .concat (sub_str s[i])
        else if l1 > l0 and l1 > l2
          len: l1
          pat: table[i+1][j].pat .concat (new_var())
        else
          len: l2
          pat: table[i][j+1].pat .concat (new_var())

  maxx = -1
  maxi = -1
  maxj = -1
  for i in [0 ... S]
    for j in [0 ... T]
      if maxx < table[i+1][j+1]
        maxx = table[i+1][j+1]
        maxi = i
        maxj = j

  ### debug
  for i in [0 .. S]
    console.warn table[i].map (obj) -> obj.len
  ###

  merge table[S][T].pat

module "GHandIJKor", "ABCandDEFor"
