require 'arst/node/base'
require 'arst/node/has_children'

module ARST
  module Node
    
    class Root < Base
      
      include HasChildren
      
    end
    
  end
end
