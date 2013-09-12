require 'arst/node/base'

module ARST
  module Node
    
    class Class < Base
      
      attr_reader :name
      
      def initialize(options={})
        super(options)
        
        # TODO: Validate keys
        self.name, self.superclass = options.values_at(:name, :superclass)
      end
      
      def name=(name)
        @name = name.to_s # TODO: Sanitize
      end
      
      def superclass=(superclass)
        @superclass = superclass.to_s unless superclass.nil? # TODO: Sanitize
      end
      
    end
    
  end
end
