module ARST
  module Node
    
    class Base
      
      attr_reader :children
      
      def initialize(options={})
        # TODO: Validate keys
        options = default_options.merge(options)
        
        @parent, @children = options.values_at(:parent, :children)
        @children.collect! { |child_options| Node.from_options( child_options.merge(parent: self) ) }
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
