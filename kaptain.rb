#!/usr/bin/env ruby
#encoding: utf-8

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file}
Dir[File.dirname(__FILE__) + '/komponents/*.rb'].each{|file| require file}
Dir[File.dirname(__FILE__) + '/modules/*.rb'].each{|file| require file}

require 'pp'

class Kaptain

  attr_reader :komponents, :irc

  def initialize()
    @komponents = []
    @irc = IRC.new

    initialize_subclasses()
  end

  def initialize_subclasses()
    Komponent.komponent_classes.each do |klass|
      @komponents << klass.new
    end
  end

  def find_komponents_for_input(msgBag)
    useful_komponents = []
    komponents.each do |komponent|
      if komponent.can_handle?(msgBag)
        useful_komponents << komponent
      end
    end
    useful_komponents
  end

  def respond_to(msgBag)
    msgBag[:content] = msgBag[:content].chomp

    useful_komponents = find_komponents_for_input(msgBag)

    if useful_komponents.size > 0
      answers = []

      useful_komponents.each do |komponent|
        answers << komponent.handle(msgBag)
      end

      answers.sample if answers.size > 0
    end
  end

  def run
    irc.connect

    until irc.socket.eof? do
      msg = irc.socket.gets
      puts msg

      case msg
        when /^PING :(.*)$/
          irc.pong $~[1]
        when /^(.+?)001 #{irc.nick} :/  
          irc.join
        when /^:(\w+)!(\S+) (\S+) (\S+) :(.+)/ 
          msgBag = {
            from: $~[1],
            host: $~[2],
            cmd: $~[3],
            to: $~[4],
            content: $~[5]
          }

          response = respond_to(msgBag)

          if msgBag[:to][0] == '#' 
            irc.say_to_chan(response, msgBag[:to]) if response
          else
            irc.say_to_user(response, msgBag[:to]) if response
          end
      end
    end
  end

end

kaptain = Kaptain.new
puts "Kaptain loaded"

begin
  kaptain.run
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  retry
end

