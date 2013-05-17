require 'arst/generator/base'

module ARST
  module Generator
    
    class Ruby < Base
      
      protected
      
      def parse_children(node, depth)
        output = ''
        
        node[:children].each do |node|
          output << '  ' * depth
          if node[:module]
            output << "module #{ node[:module] }"
          elsif node[:class]
            output << "class #{ node[:class] }"
            output << " < #{ node[:superclass] }" if node[:superclass]
          elsif node[:include]
            output << "include #{ node[:include] }"
          elsif node[:extend]
            output << "extend #{ node[:extend] }"
          end
          output << "\n"
          output << parse_children(node, depth+1) if node.has_key?(:children)
        end
        
        output
      end
      
    end
    
  end
end
