extract_pattern = require './extract-pattern'
pattern_classify = require './pattern-classify'

extract = (docs, options) ->
  if docs.positive? and docs.negative?
    patterns = extract_pattern [docs.positive, docs.negative], options
    positive: patterns[0]
    negative: patterns[1]
  else if docs instanceof Array
    extract_pattern docs, options
  else
    throw new Error docs

classify = (patterns, d) ->
  if patterns.positive? and patterns.negative?
    klass = pattern_classify [patterns.positive, patterns.negative], d
    if klass is 0 then 'positive' else 'negative'
  else if patterns instanceof Array
    pattern_classify patterns, d
  else
    throw new Error patterns

## export
exports.extract = extract
exports.classify = classify
