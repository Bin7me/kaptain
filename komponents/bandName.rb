class BandName < Komponent

  class << self
    attr_reader :PROBABILITY
  end

  @PROBABILITY = 1

  def can_handle?(input)
    if input.split.length == 3
      true
    else
      false
    end
  end

  def handle(input)
    prob = Random.rand(1.to_f)
    if prob <= self.class.PROBABILITY
      ">>#{input}<< would be a nice name for a Rock Band!"
    end
  end
end
