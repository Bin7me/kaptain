#!/usr/bin/env ruby
#encoding: utf-8

require File.join(File.dirname(__FILE__), '..', '/lib/irc.rb')

irc = IRC.new
irc.server = "irc.foo.bar"
irc.port = "6667"
irc.nick = "bin7me"
irc.channel = "#foobar"
irc.ownerinfo = "ownerinfo"

def setup
  $stdout = StringIO.new
end

describe IRC, "send(message)" do
  before do
    irc.stub!(:puts)
  end

  it "should send the message over the socket" do
    message ="foo bar"

    mock_socket = mock('TCPSocket')
    mock_socket.should_receive(:send).with("#{message}\n", 0)

    irc.socket = mock_socket

    irc.send(message)
  end

end

describe IRC, "connect" do
  before do
    irc.stub!(:puts)
  end

  it "should open a socket and send USER and NICK commands" do

    mock_socket = mock('TCPSocket')
    mock_socket.should_receive(:send).with("USER #{irc.nick} #{irc.nick} #{irc.nick} :#{irc.ownerinfo}\r\n\n", 0)
    mock_socket.should_receive(:send).with("NICK #{irc.nick}\n", 0)

    irc.socket = mock_socket

    irc.connect
  end
end

describe IRC, "join" do
  before do
    irc.stub!(:puts)
  end

  it "should send a JOIN and a PRIVMSG command" do
    mock_socket = mock('TCPSocket')
    mock_socket.should_receive(:send).with("JOIN #{irc.channel}\n", 0)
    mock_socket.should_receive(:send).with("PRIVMSG #{irc.channel} :#{irc.greeting}\n", 0)

    irc.socket = mock_socket

    irc.join
  end
end

describe IRC, "pong(ping)" do
  before do
    irc.stub!(:puts)
  end

  it "should send a PONG command containing the ping" do
    ping = "ping"

    mock_socket = mock('TCPSocket')
    mock_socket.should_receive(:send).with("PONG #{ping}\n", 0)

    irc.socket = mock_socket

    irc.pong(ping)
  end
end

describe IRC, "say_to_chan(message, channel)" do
  before do
    irc.stub!(:puts)
  end

  it "should send a PRIVMSG command with message to the channel" do
    message = "foo bar"

    mock_socket = mock('TCPSocket')
    mock_socket.should_receive(:send).with("PRIVMSG #{irc.channel} :#{message}\n", 0)

    irc.socket = mock_socket

    irc.say_to_chan(message, irc.channel)
  end
end

describe IRC, "say_to_user(message, user)" do
  before do
    irc.stub!(:puts)
  end

  it "should send a PRIVMSG command with message to the user" do
    message = "foo bar"
    user = "bin7me"

    mock_socket = mock('TCPSocket')
    mock_socket.should_receive(:send).with("PRIVMSG #{user} :#{message}\n", 0)

    irc.socket = mock_socket

    irc.say_to_chan(message, user)
  end
end
