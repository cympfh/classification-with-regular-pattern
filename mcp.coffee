###
# Minimum common pattern
###

lcs = require './lcs'
{new_var, sub_str, Pattern} = require './syntax'

split = (str, sub) ->
  ls = str.split sub
  switch
    when ls.length is 1
      throw new Error "#{str} not contains #{sub}"
    when ls.length is 2
      ls
    when ls.length > 2
      b = ls.slice(1).join sub
      [ls[0], b]

sub_mcp = (s, t) ->

  return [] if s is '' and t is ''

  a = lcs s, t

  if a is ''
    return [do new_var]

  ss = split s, a
  ts = split t, a

  (sub_mcp ss[0], ts[0]) .concat [sub_str a] .concat (sub_mcp ss[1], ts[1])

module.exports = (s, t) ->
  ls = sub_mcp s, t
