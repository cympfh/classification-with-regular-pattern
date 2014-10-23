###
# Minimum common pattern
###

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

mcp = (s, t) ->
  s = s.split ''
  t = t.split ''
  S = s.length
  T = t.length

  table = for i in [0 .. S]
    for j in [0 .. T]
      len: 0
      pat: if (i is 0 and j is 0) then [] else [(new_var())]

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

  merge table[S][T].pat

try
  mcp_core = require('./mcp/build/Release/mcp.node').mcp
  module.exports = (s, t) ->
    p = mcp_core s, t
    for i in [0 ... p.length]
      if p[i].length is 0
        new_var()
      else
        sub_str p[i]
catch e
  module.exports = mcp
