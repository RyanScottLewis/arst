require 'arst/helpers'

module ARST
  module Node
    
    class Base
      
      attr_reader :parent, :children
      
      def initialize(options={})
        # TODO: Validate keys
        options = default_options.merge(options)
        
        @parent, @children = options.values_at(:parent, :children)
        @children.collect! { |child_options| Node.from_options( child_options.merge(parent: self) ) }
      end
      
      def ancestors
        return [] if parent.nil?
        
        ( parent.ancestors || [] ) + [self]
      end
      
      def type
        @type ||= ARST::Helpers.underscore(self.class.to_s.split(/::/).last).to_sym
      end
      
      def type_is?(type)
        self.type == type
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
