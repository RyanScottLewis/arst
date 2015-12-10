require 'arst/generator/base'

module ARST
  module Generator
    
    class ARST < Base
      
      protected
      
      def parse_children(node, options={})
        output = ''
        
        node[:children].each do |node|
          output << (options[:indent_char] * options[:indent_size]) * options[:depth]
          
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
          output << parse_children( node, options.merge(depth: options[:depth]+1) ) if node.has_key?(:children)
        end
        
        output
      end
      
    end
    
  end
end
