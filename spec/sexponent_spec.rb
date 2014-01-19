#!/usr/bin/env ruby
#encoding: utf-8

require File.join(File.dirname(__FILE__), '..', '/lib/structs.rb')
require File.join(File.dirname(__FILE__), '..', '/lib/komponent.rb')
require File.join(File.dirname(__FILE__), '..', '/komponents/sexponent.rb')

require "minitest/autorun"

describe Sexponent, "can_handle?(msgBag)" do
  sexponent = Sexponent.new

  it "returns true for a message bag with :content containing 'ex'" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "A small experiment")
      
    sexponent.can_handle?(msgBag).must_equal true
  end

  it "returns true for a message bag with :content containing 'Ex'" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "A small Experiment")

    sexponent.can_handle?(msgBag).must_equal true
  end

  it "returns false for a message bag with :content containing neither 'ex' nor 'Ex'" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "A small String")

    sexponent.can_handle?(msgBag).must_equal false
  end
end

describe Sexponent, "handle(msgBag)" do
  sexponent = Sexponent.new

  it "replaces 'ex' with 'sex' in msgBag[:content] and returns it" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "ex")

    sexponent.handle(msgBag).must_equal "sex"
  end

  it "replaces 'Ex' with 'Sex' in msgBag[:content] and returns it" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "Ex")

    sexponent.handle(msgBag).must_equal "Sex"
  end

  it "returns msgBag[:content] if neither 'ex' nor 'Ex' are found" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "string")

    sexponent.handle(msgBag).must_equal "string"
  end
end
