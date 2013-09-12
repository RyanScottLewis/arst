require 'arst/node/base'
require 'arst/node/namable'

module ARST
  module Node
    
    class Class < Base
      
      include Namable
      
      attr_reader :superclass
      
      def initialize(options={})
        super(options)
        
        # TODO: Validate keys
        self.superclass = options[:superclass]
      end
      
      def superclass=(superclass)
        @superclass = superclass.to_s unless superclass.nil? # TODO: Sanitize
      end
      
    end
    
  end
end
