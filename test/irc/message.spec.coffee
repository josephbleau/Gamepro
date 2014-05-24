'use strict';

di = require 'di'

describe 'Message', () ->
  Message = null
  injector = null

  beforeEach () ->
    injector = new di.Injector [require '../../src/irc/message']
    Message = injector.get 'Message'

  describe 'constructor()', () ->
    it 'should not require new keyword', () ->
      expect(Message(':irc.foobar.org NOTICE * :*** TEST') instanceof Message).toBe true

    it 'should support new keyword', () ->
      expect(new Message(':irc.foobar.org NOTICE * :*** TEST') instanceof Message).toBe true

    it 'should return null if given non-string', () ->
      expect(Message()).toBe null

  describe 'parse()', () ->
    it 'should return null if given non-string', () ->
      expect(Message.parse()).toBe null

    it 'should parse "server"', () ->
      msg = Message.parse ':irc.foobar.org NOTICE * :*** TEST'
      expect(msg.server).toBe 'irc.foobar.org'
      expect(msg.nick).toBe null
      expect(msg.user).toBe null
      expect(msg.host).toBe null


    it 'should parse "nick", "user", and "host"', () ->
      msg = Message.parse ':nickname!~user@host.com PRIVMSG me :hi'
      expect(msg.nick).toBe 'nickname'
      expect(msg.user).toBe '~user'
      expect(msg.host).toBe 'host.com'
      expect(msg.server).toBe null


    it 'should parse user-prefix', () ->
      expect(Message.parse(':nickname!~user@host.com PRIVMSG me :hi').prefix).
        toBe 'nickname!~user@host.com'
      expect(Message.parse(':nickname!~user PRIVMSG me :hi').prefix).toBe 'nickname!~user'
      expect(Message.parse(':nickname PRIVMSG me :hi').prefix).toBe 'nickname'


    it 'should parse IPv4 user host', () ->
      expect(Message.parse(':nickname!~user@192.168.0.1 PRIVMSG me :hi').host).
        toBe '192.168.0.1'


    it 'should parse IPv6 user host', () ->
      expect(Message.parse(':nickname!~user@0:0:0:0:0:0:0:1 PRIVMSG me :hi').host).
        toBe '0:0:0:0:0:0:0:1'


    it 'should parse params', () ->
      expect(Message.parse(':nickname!~user@host.com PRIVMSG me :hello world!').params).
        toBe 'me :hello world!'
