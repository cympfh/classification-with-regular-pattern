ep = require './extract-pattern'
get_score = require './score'
{pattern2str} = require './syntax'

module.exports = (TP, TQ, U, options) ->
  options = {} if not options

  if options.balance
    N = Math.max TP.length, TQ.length
    TP = TP[0 ... N]
    TQ = TQ[0 ... N]

  if options.iteration
    iteration = options.iteration
  else
    iteration = (TP.length / 9) | 0

  if options.threshold
    threshold = options.threshold
  else
    threshold = null

  PiP = ep iteration, threshold, TP, TQ
  PiQ = ep iteration, threshold, TQ, TP

  score =
    P: 0
    N: 0
    Q: 0

  U.forEach (d) ->
    score_P = get_score d, PiP, TP, TQ
    score_Q = get_score d, PiQ, TQ, TP
    switch
      when score_P > score_Q then ++score.P
      when score_P < score_Q then ++score.Q
      else ++score.N

  return score
  
