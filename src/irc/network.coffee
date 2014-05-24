debug = require 'debug'
log = debug 'Network'

class Network
  constructor: (@factory, @user, @host, @port) ->
    @socket = @factory.TCP.socket @host, @port

  connect: () ->
    onconnect = (reason) ->
      log 'connection success: #{reason}'

    onerror = (reason) ->
      log 'connection failed: #{reason}'

    promise = @factory.Promise (resolve, reject) ->
      @socket.connect().then onconnect, onerror

class NetworkFactory
  @$inject: ['Promise', 'TCP']

  constructor: (@Promise, @TCP) ->

  create (host, port) -> new Network(@, user, host, port)

module.exports =
  'Network': ['type', 'Network', NetworkFactory]
