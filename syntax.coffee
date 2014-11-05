new_var = do ->
  counter = 0
  ->
    {var: counter++}

sub_str = (str) ->
  {str: str}

can_generalize = (p, str) ->
  ls =
    p.filter (o) -> o.str?
      .map (o) -> o.str
  for i in [0 ... ls.length]
    t = ls[i]
    idx = str.indexOf t
    return false if idx is -1
    str = str.slice idx + t.length
  return true

pattern2str = (p) ->
  p = p.pattern if p.pattern?
  each = (o) ->
    switch
      when o.str? then o.str
      when o.var? then "(x)"
      when o.var? then "(x#{o.var})"
      else o.toString()
  p.map each
    .join ''

noteq = (p, q) ->
  return true if p.length isnt q.length
  I = p.length
  for i in [0 ... I]
    if p[i].str?
      if q[i].str?
        return true if p[i].str isnt q[i].str
      else
        return true
    else
      if q[i].str?
        return true
  false

exports.new_var = new_var
exports.sub_str = sub_str
exports.can_generalize = can_generalize
exports.pattern2str = pattern2str
exports.noteq = noteq
