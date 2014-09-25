lcs = require './lcs'

assert = (s, t, ans) ->
  a = lcs s, t
  console.assert (ans is a), "#{s}, #{t} => #{a}; expected: #{ans}"

assert 'ABC', 'ABCD', 'ABC'
assert 'ABAB', 'BAB', 'BAB'
assert 'AACCCCCAA', 'BBCCCCBB', 'CCCC'

assert 'ABAB', 'BABA', 'ABA' # or 'BAB'
assert 'BABA', 'ABAB', 'BAB' # or 'ABA'

assert 'ABABAB', 'ABABAB', 'ABABAB'
assert 'ABABAB', 'ababab', ''
