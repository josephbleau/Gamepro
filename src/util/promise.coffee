'use strict';

debug = require 'debug'
log = debug 'promise'

if process.execArgv.indexOf '--harmony' < 0 and Promise
  log "native Promise is available un-prefixed (Node.js #{process.version})"

Promise = Promise || (require 'es6-promise').Promise

module.exports =
  'Promise': ['value', 'Promise', Promise]
