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

  def say(message)
    puts "--> #{message}"
    @socket.send("#{message}\n", 0)
  end

  def connect()
    @socket = TCPSocket.open(server, port)
    say "USER #{nick} #{nick} #{nick} :#{nick}\r\n"
    say "NICK #{nick}"
  end

  def join()
    say "JOIN ##{channel}"
    say "PRIVMSG ##{channel} :Hello everyone!"
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

  def answer(input)
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
          say "PONG #{$~[1]}" 
        when /^(.+?)001 kaptain :/  
          join
        else
          response = answer(msg)
          say "PRIVMSG ##{channel} : #{response}" if response
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

