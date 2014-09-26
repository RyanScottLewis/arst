require 'arst/node/scoped_keyword'

module ARST
  module Node
    
    # The node for the `class` keyword.
    class ClassKeyword < ScopedKeyword
      
      # Get the superclass for this instance.
      attr_reader :superclass
      
      # Set the superclass for this instance.
      def superclass=(superclass)
        # TODO: Sanitize `superclass` given
        @superclass = superclass.to_s.strip
      end
      
    end
    
  end
end
