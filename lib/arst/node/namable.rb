module ARST
  module Node
    
    module Namable
      
      attr_reader :name
      
      def initialize(options={})
        super(options)
        
        # TODO: Validate keys
        self.name = options[:name]
      end
      
      def name=(name)
        @name = name.to_s # TODO: Sanitize
      end
      
    end
    
  end
end
