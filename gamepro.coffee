#!/usr/bin/env coffee

di = require 'di'

module = require './src'
injector = new di.Injector [module]

NetworkFactory = injector.get 'Network'
network = NetworkFactory.create 'irc.freenode.net', 6667

network.on 'data', (buffer) ->
  text = buffer
  if typeof buffer is "object"
    text = buffer.toString 'utf8'
  console.log text

network.connect().
  then () ->
    console.log "Connected"
