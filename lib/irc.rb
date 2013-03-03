require 'socket'
require_relative '../modules/configreader'

class IRC
  include ConfigReader

  attr_reader :server, :port, :nick, :channel, :socket

  def initialize()
    @server = value_for(:server)
    @port = value_for(:port)
    @nick = value_for(:nick)
    @channel = value_for(:channel)
  end

  def send(message)
    puts "--> #{message}"
    @socket.send("#{message}\n", 0)
  end

  def connect()
    @socket = TCPSocket.open(server, port)
    send "USER #{nick} #{nick} #{nick} :#{nick}\r\n"
    send "NICK #{nick}"
  end

  def join()
    send "JOIN ##{channel}"
    send "PRIVMSG ##{channel} :Hello everyone!"
  end

  def pong(ping)
    send "PONG #{ping}" 
  end

  def say_to_chan(message, channel)
    send "PRIVMSG ##{channel} :#{message}"
  end

  def say_to_user(message, user)
    send "PRIVMSG #{user} :#{message}"
  end
end
