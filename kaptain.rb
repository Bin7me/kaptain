#!/usr/bin/env ruby
#encoding: utf-8

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file}
Dir[File.dirname(__FILE__) + '/komponents/*.rb'].each{|file| require file}
Dir[File.dirname(__FILE__) + '/modules/*.rb'].each{|file| require file}

require 'pp'

class Kaptain

  attr_reader :komponents, :irc
  attr_accessor :commands_hash

  def initialize()
    @commands_hash = Hash.new()
    @komponents = []
    @irc = IRC.new

    initialize_subclasses()
  end

  def initialize_subclasses()
    Komponent.komponent_classes.each do |klass|
      instance = klass.new

      pp instance.commands
      instance.commands.each do |command|
        commands_hash[command] ||= []
        commands_hash[command] << instance
      end
      
      @komponents << instance
    end
  end

  def find_komponents_for_input(msgBag)
    useful_komponents = []

    commands_hash[msgBag[:cmd]] ||= []
    komponents_for_cmd = commands_hash[msgBag[:cmd]]

    pp komponents_for_cmd
    
    komponents_for_cmd.each do |komponent|
      if komponent.can_handle?(msgBag)
        useful_komponents << komponent
      end
    end
    useful_komponents
  end

  def respond_to(msgBag)
    msgBag[:content] = "" if msgBag[:content].nil?
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
        when /^PING :(.*)$/ #respond to pings
          irc.pong $~[1]
        when /^(.+?)001 #{irc.nick} :/ #wait until the right moment to join 
          irc.join
        when /^:(\w+)!(\S+) (\S+) (\S+) :(.+)/ #repsond to chan or query msgs and parts
          msgBag = MsgBag.new($~[1], $~[2], $~[3].to_sym, $~[4], $~[5])

          response = respond_to(msgBag)
          pp msgBag

          if msgBag[:to][0] == '#' 
            irc.say_to_chan(response, msgBag[:to]) if response
          else
            irc.say_to_user(response, msgBag[:from]) if response
          end
        when /^:(\w+)!(\S+) (\S+) :(.+)/ #respond to joins
          msgBag = MsgBag.new($~[1], $~[2], $~[3].to_sym, $~[4], nil)

          response = respond_to(msgBag)
          pp msgBag

          irc.say_to_chan(response, msgBag[:to]) if response
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

