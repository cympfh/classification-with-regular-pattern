fs = require 'fs'
module.exports = (fn) ->
  ls = fs.readFileSync fn, 'utf8'
  ls = ls.split /[。\n\t\s]/g
  ls.filter (s) -> not not s
