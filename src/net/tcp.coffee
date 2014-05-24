net = require 'net'

class TCPSocket
  constructor: (@factory, host, port) ->
    @host = @port = null
    @__set_hostport host, port
    @socket = new net.Socket
    @

  __set_hostport: (host, port) ->
    if typeof host is "number"
      @port = host
    else if typeof @host is "string"
      if parseInt @host is parseInt @host
        @port = @host
      else if (match = /:(\d+)\s*$/.exec @host)?
        @host = @host.substring 0, match.index
        @port = parseInt match[1]

  on: (event, listener) ->
    @socket.on event, listener
    @

  off: (event, listener) ->
    @socket.off event, listener
    @

  connect: (host, port) ->
    @__set_hostport host, port
    args = []
    args.push @port if @port?
    args.push @host if @host?

    promise = new @factory.Promise (resolve, reject) ->
      onconnect = () ->
        unbind()
        resolve(new Array ...)
      onerror = () ->
        unbind()
        reject(new Array ...)
      unbind = () ->
        @socket.off 'connect', onconnect
        @socket.off 'error', onerror
      @socket.on 'connect', onconnect
      @socket.on 'error', onerror
      @socket.connect args...

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

  socket: (port, host) ->
    new TCPSocket(@, host, port)
