debug = require 'debug'
log = debug 'MessageParser'
net = require 'net'
_ = require 'lodash'

MESSAGE_REGEXP = /^(?:\:([^ ]+)\ +)?([^\ ]+(?:\s+(?:\s*[^\ \:]+)+))(?:\s*\:(.+))?$/

HOST_REGEXP   = /^[a-zA-Z0-9][a-zA-Z0-9-]*(?:\.[a-zA-Z0-9][a-zA-Z0-9-]*)+/
USER_BASIC_REGEXP = /^([^\!]+)(?:\!([^@]+)(?:\@([^\s\r\n]+))?)?$/
NICKNAME_REGEXP = /^[a-zA-Z;\[\]\\\`\_\^\{\|\}][a-zA-Z0-9;\[\]\\\`\_\^\{\|\}-]*$/
USER_REGEXP = /^[^\x00\x41\r\n @]+$/

parseServer = (prefix) ->
  match = HOST_REGEXP.exec prefix
  if match?
    return {
      server: prefix
      nick: null
      user: null
      host: null
    }

parseUser = (prefix) ->
  match = USER_BASIC_REGEXP.exec prefix
  if match?
    nick = NICKNAME_REGEXP.exec match[1]
    if nick?
      nick = nick[0]
      if match[2]?
        user = USER_REGEXP.exec match[2]
        if not user?
          return
        if match[3]?
          user = user[0]
          host = HOST_REGEXP.exec match[3]
          if host?
            host = host[0]
          else if net.isIPv4(match[3]) or net.isIPv6(match[3])
            host = match[3]
          else
            return
      return {
        server: null
        nick: nick
        user: user
        host: host
      }
  null

parsePrefix = (prefix) ->
  prefix = prefix || ''
  parseServer(prefix) || parseUser(prefix)

class MessageOptions
  constructor: (@options) ->

class Message
  @$inject: []

  constructor: (message) ->
    self = @
    if self instanceof Message
      if message instanceof MessageOptions
        _.merge self, message.options
        message.options = message = null
        return self

    if typeof message is "string"
      return Message.parse message, @

    return null

  @parse: (message, self) ->
    if self not instanceof Message
      self = null

    create = (obj) ->
      if self? then obj = self.constructor(obj) else obj = new Message(obj)
      obj

    msg =
      prefix: ''
      command: ''
      params: ''
      server: null
      nick: null
      user: null
      host: null
      raw: ''

    if typeof message is "string"
      msg.raw = message
      match = MESSAGE_REGEXP.exec message

      if match?
        command = (match[2] or '').split /\s+/;
        msg.prefix = match[1] if match[1]?
        msg.command = command.shift();
        msg.params = command;
        msg.text = match[3];

        match = parsePrefix msg.prefix
        if match?
          msg.server = match.server
          msg.nick = match.nick
          msg.user = match.user
          msg.host = match.host

      return create(new MessageOptions msg)
    null

  prefix: null
  command: null
  params: null
  server: null
  nick: null
  user: null
  host: null
  text: null
  raw: ''

module.exports =
  'Message': ['value', Message]
