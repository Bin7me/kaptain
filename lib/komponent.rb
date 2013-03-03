require_relative '../modules/configreader'
class Komponent
  include ConfigReader

  class << self
    attr_reader :komponent_classes
  end

  @komponent_classes = []

  def initialize
    post_construct
  end

  def post_construct()
    #to be overwritten by subclasses
  end

  def can_handle?(input)
    false
  end

  def handle(input)
    input 
  end

  def self.inherited(subclass)
    self.komponent_classes << subclass
  end

end
