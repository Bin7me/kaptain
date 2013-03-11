#!/usr/bin/env ruby
#encoding: utf-8

require File.join(File.dirname(__FILE__), '..', '/lib/structs.rb')
require File.join(File.dirname(__FILE__), '..', '/lib/komponent.rb')
require File.join(File.dirname(__FILE__), '..', '/komponents/bandName.rb')

describe BandName, "can_handle?(msgBag)" do
  bandName = BandName.new
  bandName.probability = 1.to_f

  it "can handle a message bag with :content consisting of three words" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "one two three")

    bandName.can_handle?(msgBag).should eq(true)
  end

  it "doesn't handle a message bag with :content having a wordcount != three" do
    msgBagTooShort = MsgBag.new(nil, nil, nil, nil, "one two")
    msgBagTooLong = MsgBag.new(nil, nil, nil, nil, "one two three four")

    bandName.can_handle?(msgBagTooShort).should eq(false)
    bandName.can_handle?(msgBagTooLong).should eq(false)
  end
end

describe BandName, "handle(msgBag)" do
  bandName =BandName.new
  bandName.probability = 1.to_f

  it "announces that msgBag[:content] would be a nice name for a rock band" do
    msgBag = MsgBag.new(nil, nil, nil, nil, "three word band")

    bandName.handle(msgBag).should eq(">>three word band<< would be a nice name for a Rock Band!")
  end
end
