require 'arst/node/root'
require 'arst/node/module'
require 'arst/node/class'
require 'arst/node/include'
require 'arst/node/extend'

module ARST
  
  module Node
    
    def self.from_options(options)
      case options[:type]
      when 'module'  then Node::Module.new(options)
      when 'class'   then Node::Class.new(options)
      when 'extend'  then Node::Extend.new(options)
      when 'include' then Node::Include.new(options)
      else
        # TODO: Raise ARST::Error::InvalidNodeType
      end
    end
    
  end
  
end