require 'arst/generator/ruby'
require 'arst/generator/c'

module ARST
  
  module Generator
    
    def self.generate(generator_type, node, options={})
      const_get(generator_type.to_s.capitalize).generate(node, options)
    end
    
  end
  
end
