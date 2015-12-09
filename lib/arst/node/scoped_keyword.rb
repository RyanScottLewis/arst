require 'arst/node/keyword'
require 'arst/node/has_children'

module ARST
  module Node
    
    # The base class for keyword nodes within the syntax tree.
    class ScopedKeyword < Keyword
      
      include HasChildren
      
      # Get the parent of this keyword.
      attr_reader :parent
      
    end
    
  end
end
