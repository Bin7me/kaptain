#!/usr/bin/env ruby
#encoding: utf-8

require File.join(File.dirname(__FILE__), '..', '/lib/structs.rb')
require File.join(File.dirname(__FILE__), '..', '/lib/komponent.rb')
require File.join(File.dirname(__FILE__), '..', '/komponents/sexponent.rb')

describe Sexponent, "can_handle?(msgBag)" do
  it "can handle a message bag with :content containing 'ex'" do
    sexponent = Sexponent.new

    msgBag = MsgBag.new(nil, nil, nil, nil, "A small experiment")
      
    sexponent.can_handle?(msgBag).should eq(true)
  end

  it "can handle a message bag with :content containing 'Ex'" do
    sexponent = Sexponent.new

    msgBag = MsgBag.new(nil, nil, nil, nil, "A small Experiment")

    sexponent.can_handle?(msgBag).should eq(true) 
  end

  it "doesn't handle a message bag with :content containing neither containing 'ex' nor 'Ex'" do
    sexponent = Sexponent.new

    msgBag = MsgBag.new(nil, nil, nil, nil, "A small String")

    sexponent.can_handle?(msgBag).should eq(false) 
  end
end

describe Sexponent, "handle(msgBag)" do
  it "replaces 'ex' with 'sex' in msgBag[:content] and returns it" do
    sexponent = Sexponent.new

    msgBag = MsgBag.new(nil, nil, nil, nil, "ex")

    sexponent.handle(msgBag).should eq("sex")
  end

  it "replaces 'Ex' with 'Sex' in msgBag[:content] and returns it" do
    sexponent = Sexponent.new

    msgBag = MsgBag.new(nil, nil, nil, nil, "Ex")

    sexponent.handle(msgBag).should eq("Sex")
  end

  it "returns msgBag[:content] if neither 'ex' nor 'Ex' are found" do
    sexponent = Sexponent.new

    msgBag = MsgBag.new(nil, nil, nil, nil, "string")

    sexponent.handle(msgBag).should eq("string")
  end
end
