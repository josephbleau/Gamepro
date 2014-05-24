merge = require './util/merge'
merge module.exports, [
  require './util'
  require './net'
  require './irc'
]
