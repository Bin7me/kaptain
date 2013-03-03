class BandName < Komponent

  attr_reader :probability

  def post_construct()
    @probability = value_for(:probability).to_f
  end

  def can_handle?(input)
    if input.split.length == 3
      true
    else
      false
    end
  end

  def handle(input)
    prob = Random.rand(1.to_f)
    if prob <= probability
      ">>#{input}<< would be a nice name for a Rock Band!"
    end
  end
end
