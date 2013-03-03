#!/usr/bin/env ruby
#encoding: utf-8

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file}
Dir[File.dirname(__FILE__) + '/komponents/*.rb'].each{|file| require file}
Dir[File.dirname(__FILE__) + '/modules/*.rb'].each{|file| require file}

require 'pp'
require 'socket'

class Kaptain
  include ConfigReader

  attr_reader :komponents, :server, :port, :nick, :channel

  def initialize()
    @komponents = []
    
    @server = value_for(:server)
    @port = value_for(:port)
    @nick = value_for(:nick)
    @channel = value_for(:channel)

    initialize_subclasses()
  end

  def initialize_subclasses()
    Komponent.komponent_classes.each do |klass|
      @komponents << klass.new
    end
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

  def say(message, channel)
    send "PRIVMSG ##{channel} :#{message}"
  end

  def find_komponents_for_input(input)
    useful_komponents = []
    komponents.each do |komponent|
      if komponent.can_handle?(input)
        useful_komponents << komponent
      end
    end
    useful_komponents
  end

  def respond_to(input)
    input.chomp!

    useful_komponents = find_komponents_for_input(input)

    if useful_komponents.size > 0
      answers = []

      useful_komponents.each do |komponent|
        answers << komponent.handle(input)
      end

      answers.sample if answers.size > 0
    end
  end

  def run
    until @socket.eof? do
      msg = @socket.gets
      puts msg

      case msg
        when /^PING :(.*)$/
          send "PONG #{$~[1]}" 
        when /^(.+?)001 kaptain :/  
          join
        when /^:(\w+)!(\S+) PRIVMSG #(\S+) :(.+)/ 
          if $~[3] == channel
            puts "[LOG] Someone wrote something!"
            response = respond_to($~[4])
            say(response, channel) if response
          end
      end
    end
  end

end

kaptain = Kaptain.new
puts "Kaptain loaded"
kaptain.connect

begin
  kaptain.run
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  retry
end

