require 'arst/node/root'
require 'arst/node/module'
require 'arst/node/class'
require 'arst/node/include'
require 'arst/node/extend'
require 'arst/node/def'

module ARST
  
  module Node
    
    # TODO: Rename to something more specific... from_raw_tree?
    def self.from_options(options)
      case options[:type]
      when 'module'  then Node::Module.new(options)
      when 'class'   then Node::Class.new(options)
      when 'extend'  then Node::Extend.new(options)
      when 'include' then Node::Include.new(options)
      when 'def'     then Node::Def.new(options)
      else
        # TODO: Raise ARST::Error::InvalidNodeType
      end
    end
    
  end
  
end
