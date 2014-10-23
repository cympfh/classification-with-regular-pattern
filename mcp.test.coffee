mcp = require './mcp'

variable = []

assert = (s, t, result) ->
  p = mcp s, t
  
  I = p.length
  J = result.length

  if I isnt J
    console.warn "expected: %j,\nbut %j", result, p
    console.warn "hint: the lengths are different"
    process.exit 1

  for i in [0 ... I]
    e = p[i]
    r = result[i]

    if e.str? and e.str is r
      # ok
    else if e.var? and r is variable
      # ok
    else
      console.warn "expected: %j, but %j", result, p
      console.warn "hint: '#{r}' and '#{e.str}'"
      process.exit 1

assert 'This is X', 'This is Y' , ['This is ', variable]
assert 'Cat and dog', 'Cats and dogs', ['Cat',variable,' and dog',variable]
assert '１日に、44回も夕ぐれを見たことがあるよ！'
  , 'その44回ながめた日は、じゃあすっごくせつなかったの？'
  , [variable, '44回', variable, 'た', variable, 'あ', variable]

assert 'empty is not allowed', 'empty is allowed'
  , ['empty is ', variable, 'allowed']

assert 'ABCXYcZT', 'XYZTABC', [variable, 'XY', variable, 'ZT', variable]
