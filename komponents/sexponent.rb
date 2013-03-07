class Sexponent < Komponent

  attr_reader :regsex

  def post_construct()
    @regsex = /\bex\w*/i
  end

  def can_handle?(msgBag)
    if msgBag [:content] =~ regsex 
      true
    else
      false
    end
  end

  def handle(msgBag)
    msgBag[:content].gsub!("ex", "sex")
    msgBag[:content].gsub!("Ex", "Sex")
    msgBag[:content]
  end
end
