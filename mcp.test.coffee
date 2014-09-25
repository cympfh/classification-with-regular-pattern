mcp = require './mcp'

assert = (s, t, q) ->
  p = mcp s, t
  console.assert (p.length is q.length), "#{JSON.stringify p}, #{JSON.stringify q}"
  for i in [0 ... p.length]
    a = p[i]
    b = q[i]
    console.assert ((a.str? and b.str? and a.str is b.str) or (a.var? and b.var?))
    , "#{JSON.stringify p}, #{JSON.stringify q}"

assert 'This is X', 'This is Y', [{str:'This is '}, {var:0}]
assert 'Cat and dog', 'Cats and dogs', [{str:'Cat'}, {var:1},{str:' and dog'},{var:2}]
assert '１日に、44回も夕ぐれを見たことがあるよ！'
  , 'その44回ながめた日は、じゃあすっごくせつなかったの？'
  , [{"var":3},{"str":"44回"},{"var":4},{"str":"た"},{"var":5},{"str":"あ"},{"var":6}]

assert 'The empty is allowed', 'empty is allowed'
  , [{"var":7},{"str":"empty is allowed"}]
