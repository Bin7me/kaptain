require_relative '../modules/configreader'
class Komponent
  include ConfigReader

  class << self
    attr_reader :komponent_classes
  end

  attr_reader :commands

  @komponent_classes = []

  def initialize
    @commands = []
    post_construct
  end

  def post_construct()
    #to be overwritten by subclasses
  end

  def can_handle?(msgBag)
    false
  end

  def handle(msgBag)
  end

  def self.inherited(subclass)
    self.komponent_classes << subclass
  end

end
