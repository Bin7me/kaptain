class Komponent

  class << self
    attr_reader :komponent_classes
  end

  @komponent_classes = []

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
