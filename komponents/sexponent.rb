class Sexponent < Komponent

  class << self
    attr_reader :REGSEX
  end

  @REGSEX = /\bex\w*/i

  def can_handle?(input)
    if input =~ self.class.REGSEX
      true
    else
      false
    end
  end

  def handle(input)
    input.gsub!("ex", "sex")
    input.gsub!("Ex", "Sex")
    input
  end
end
