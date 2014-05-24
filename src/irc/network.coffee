debug = require 'debug'
log = debug 'Network'

class Network
  constructor: (@factory, @user, @host, @port) ->
    @socket = @factory.TCP.socket @host, @port

  on: (event, listener) ->
    @socket.on arguments...
    @

  off: (event, listener) ->
    @socket.off  arguments...
    @

  connect: () ->
    socket = @socket
    promise = new @factory.Promise (resolve, reject) ->
      onconnect = (reason) ->
        log "connection success: #{reason or ':)'}"

      onerror = (reason) ->
        log "connection failed: #{reason}"

      log "connecting to #{socket}..."
      socket.connect().then onconnect, onerror

class NetworkFactory
  @$inject: ['Promise', 'TCP']

  constructor: (@Promise, @TCP) ->

  create: (host, port) -> new Network(@, {}, host, port)

module.exports =
  'Network': ['type', NetworkFactory]
