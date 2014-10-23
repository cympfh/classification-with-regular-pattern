read = require '../read'
pattern = require '../index'
fs = require 'fs'

docs = [
  {class: 'Dazai', content: read './doc/d_a'}
  {class: 'Dazai', content: read './doc/d_b'}
  {class: 'Dazai', content: read './doc/d_c'} # 女生徒
  {class: 'Shimazaki', content: read './doc/s_a'} # 嵐
  {class: 'Shimazaki', content: read './doc/s_b'}
  {class: 'Shimazaki', content: read './doc/s_c'}
]

console.warn "stat"
for d in docs
  console.warn "#{d.content.length} sentences"


training_datum =
  positive: docs[2].content[0 ... 1000]
  negative: docs[3].content[0 ... 1000]

options =
  threshold: 0
  iterate: 400

patterns =
  pattern.extract training_datum, options

fs.writeFileSync './learned.json', (JSON.stringify patterns)

# test
for d in docs
  result = pattern.classify patterns, d.content
  label = if result is 'positive' then 'Dazai' else 'Shimazaki'
  console.log "result is #{label} and expected is #{d.class}"
