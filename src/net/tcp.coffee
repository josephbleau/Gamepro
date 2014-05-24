net = require 'net'
debug = require 'debug'
log = debug 'TCP'

class TCPSocket
  constructor: (@factory, host, port) ->
    log "new TCPSocket: #{host}, #{port}"
    @host = @port = null
    @__set_hostport host, port
    @socket = new net.Socket
    @

  toString: () ->
    host = @host
    if not host? then host = 'localhost'
    "#{host}:#{@port}"

  __set_hostport: (host, port) ->
    if typeof port is "string" then port = Number port
    if typeof host is "number" then @port = host
    else if typeof host is "string"
      tmp = Number host
      if tmp is tmp then @port = tmp
      else if (match = /:(\d+)\s*$/.exec host)?
        @host = host.substring 0, match.index
        @port = parseInt match[1]
      else
        @host = host
        if port?
          @port = Number port

  on: (event, listener) ->
    @socket.on event, listener
    @

  once: (event, listener) ->
    @socket.once event, listener
    @

  off: (event, listener) ->
    @socket.removeListener event, listener
    @

  connect: (host, port) ->
    @__set_hostport host, port
    args = []
    socket = @socket
    args.push @port if @port?
    args.push @host if @host?

    promise = new @factory.Promise (resolve, reject) ->
      onconnect = () ->
        resolve(new Array ...)
      onerror = () ->
        reject(new Array ...)
      socket.once 'connect', onconnect
      socket.once 'error', onerror
      socket.connect args...

  send: (data, encoding) ->
    args = []
    args.push data if data?
    args.push encoding if encoding?
    promise = new @factory.Promise (resolve) ->
      args.push resolve
      @socket.write arguments...

class TCPFactory
  @$inject: ['Promise']

  constructor: (@Promise) ->

  socket: (host, port) -> new TCPSocket(@, host, port)

module.exports =
  'TCP': ['type', TCPFactory]