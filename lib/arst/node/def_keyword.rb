require 'arst/node/keyword'

module ARST
  module Node
    
    class DefKeyword < Keyword
      
      # Get the arguments for this keyword.
      attr_accessor :arguments
      
      # Set the arguments for this keyword.
      def arguments=(value)
        @arguments = value.to_s.strip # TODO: Parse
      end
      
    end
    
  end
end
