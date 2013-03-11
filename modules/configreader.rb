require 'parseconfig'

module ConfigReader
  CONFIG_NAME = File.join(File.dirname(__FILE__), '..', 'kaptain.cfg')
  CONFIG = ParseConfig.new(CONFIG_NAME)

  def value_for(attribute)
    name = self.class.to_s.downcase
    CONFIG[name][attribute.downcase.to_s]
  end
end
