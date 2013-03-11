class BandName < Komponent

  attr_accessor:probability

  def post_construct()
    @probability = value_for(:probability).to_f
  end

  def can_handle?(msgBag)
    if msgBag[:content].split.length == 3
      true
    else
      false
    end
  end

  def handle(msgBag)
    prob = Random.rand(1.to_f)
    if prob <= probability
      ">>#{msgBag[:content]}<< would be a nice name for a Rock Band!"
    end
  end
end
