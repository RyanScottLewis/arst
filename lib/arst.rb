require 'version'
require 'arst/parser'

# Abstract Ruby Tree (ART or ARbT in the wild) is a high-level syntax denoting the object domain of a Ruby project.
module ARST
  is_versioned
  
  # Parse the ART syntax.
  def self.parse(input)
    Parser.parse(input)
  end
  
end
