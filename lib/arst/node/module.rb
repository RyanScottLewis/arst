require 'arst/node/base'

module ARST
  module Node
    
    class Module
      
      attr_reader :name
      
      def initialize(options={})
        super
        
        # TODO: Validate keys
        @name = options.values_at(:name)
      end
      
      def name=(name)
        @name = name.to_s # TODO: Sanitize name
      end
      
    end
    
  end
end
