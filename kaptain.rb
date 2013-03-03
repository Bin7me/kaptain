#!/usr/bin/env ruby
#encoding: utf-8

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each{|file| require file}
Dir[File.dirname(__FILE__) + '/komponents/*.rb'].each{|file| require file}
require 'pp'

class Kaptain
  attr_reader :komponents
  attr_accessor :running

  def initialize()
    @running = true
    @komponents = []
    initialize_subclasses()
  end

  def initialize_subclasses()
    Komponent.komponent_classes.each do |klass|
      @komponents << klass.new
    end
  end

  def time_to_quit?(input)
    if input =~ /\/quit/
      @running = false
    end
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

    time_to_quit?(input)

    useful_komponents = find_komponents_for_input(input)

    if useful_komponents.size > 0
      answers = []

      useful_komponents.each do |komponent|
        answers << komponent.handle(input)
      end

      answers.sample if answers.size > 0
    end

  end
end

def main_loop()
  kaptain = Kaptain.new

  puts "Kaptain loaded"

  while kaptain.running do
    print "> "
    input = gets
    pp kaptain.answer(input)
  end
end

main_loop
