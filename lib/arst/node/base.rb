module ARST
  module Node
    
    class Base
      
      attr_reader :children
      
      def initialize(options={})
        # TODO: Validate keys
        options = default_options.merge(options)
        
        @children = options.values_at(:children)
      end
      
      protected
      
      def default_options
        {
          children: []
        }
      end
      
    end
    
  end
end
