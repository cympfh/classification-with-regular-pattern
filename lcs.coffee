###
# Longest Common Substring
#
# the substring must be continuous in the original strings
# ref: http://en.wikipedia.org/wiki/Longest_common_substring_problem#Dynamic_programming
###

module.exports = (s, t) ->
  S = s.length
  T = t.length
  table = for i in [0 .. S]
    for j in [0 .. T]
      0

  for i in [0 ... S]
    for j in [0 ... T]
      if s[i] is t[j]
        table[i+1][j+1] = table[i][j] + 1
      else
        table[i+1][j+1] = 0


  maxx = -1
  maxi = -1
  maxj = -1
  for i in [0 ... S]
    for j in [0 ... T]
      if maxx < table[i+1][j+1]
        maxx = table[i+1][j+1]
        maxi = i
        maxj = j

  ###
  for i in [0 .. S]
    console.warn table[i]
  console.warn "s = ", s
  console.warn "x, i = ", maxx, maxi
  ###

  s[maxi - maxx + 1 ... maxi + 1]
