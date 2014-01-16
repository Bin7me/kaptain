require 'socket'
require_relative '../modules/configreader'

class IRC
  include ConfigReader

  attr_accessor :server, :port, :nick, :channel, :socket, :ownerinfo, :greeting

  def initialize()
    @server = value_for(:server)
    @port = value_for(:port)
    @nick = value_for(:nick)
    @channel = "#" << value_for(:channel)
    @ownerinfo = value_for(:ownerinfo)
    @greeting ||= "Hello everyone!"
  end

  def send(message)
    puts "--> #{message}"
    socket.send("#{message}\n", 0)
  end

  def connect()
    @socket ||= TCPSocket.open(server, port)
    send "USER #{nick} #{nick} #{nick} :#{ownerinfo}\r\n"
    send "NICK #{nick}"
  end

  def join()
    send "JOIN #{channel}"
    send "PRIVMSG #{channel} :#{greeting}"
  end

  def pong(ping)
    send "PONG #{ping}" 
  end

  def say_to_chan(message, channel)
    msg = "PRIVMSG #{channel} :#{message}"
    puts msg
    send msg
  end

  def say_to_user(message, user)
    msg = "PRIVMSG #{user} :#{message}"
    puts msg
    send msg
  end
end
