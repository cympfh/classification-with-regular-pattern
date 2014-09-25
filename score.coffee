{can_generalize, pattern2str} = require './syntax'

score = (d, Pi, TP, TQ, debug = false) ->
  sum = 0
  Pi.filter (p) -> can_generalize p, d
    .forEach (p) ->
      positive =
        TP.filter (e) -> can_generalize p, e
          .length

      negative =
        TQ.filter (e) -> can_generalize p, e
          .length

      if debug
        console.warn "pattern,", (pattern2str p)
        console.warn "d-score = #{positive} - #{negative}"

      sum += positive - negative
  sum

module.exports = score
