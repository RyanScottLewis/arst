module ARST
  module Generator
    
    class Base
      
      def self.generate(tree, options={})
        new(tree).generate(options)
      end
      
      def initialize(tree)
        @tree = tree
      end
      
      def generate(options={})
        parse_children(@tree, 0)
      end
      
      protected
      
      def parse_children(node, depth)
        raise NotImplementedError
      end
      
    end
    
  end
end
