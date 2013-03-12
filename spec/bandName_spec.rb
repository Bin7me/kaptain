#!/usr/bin/env ruby
#encoding: utf-8

require File.join(File.dirname(__FILE__), '..', '/lib/structs.rb')
require File.join(File.dirname(__FILE__), '..', '/lib/komponent.rb')
require File.join(File.dirname(__FILE__), '..', '/komponents/bandName.rb')

describe BandName, "can_handle?(msgBag)" do
  bandName = BandName.new
  bandName.probability = 1.to_f

  it "returns true for a message bag with :content consisting of three words" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "one two three")

    bandName.can_handle?(msgBag).should eq(true)
  end

  it "returns false for a message bag with :content having a wordcount != three" do
    msgBagTooShort = MsgBag.new(nil, nil, nil, nil, "one two")
    msgBagTooLong = MsgBag.new(nil, nil, nil, nil, "one two three four")

    bandName.can_handle?(msgBagTooShort).should eq(false)
    bandName.can_handle?(msgBagTooLong).should eq(false)
  end
end

describe BandName, "handle(msgBag)" do
  bandName =BandName.new

  it "returns a string announcing that msgBag[:content] would be a nice name for a rock band if probability is met" do
    bandName.probability = 1.to_f
    msgBag = MsgBag.new(nil, nil, nil, nil, "three word band")

    bandName.handle(msgBag).should eq(">>three word band<< would be a nice name for a Rock Band!")
  end

  it "returns nil if probability is not met" do
    bandName.probability = -1.to_f
    msgBag = MsgBag.new(nil, nil, nil, nil, "three word band")

    bandName.handle(msgBag).should eq(nil)
  end
end
