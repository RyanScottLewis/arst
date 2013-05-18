require 'arst/generator/base'

module ARST
  module Generator
    
    class Ruby < Base
      
      protected
      
      def default_options
        {
          depth: 0,
          indent_size: 2,
          indent_char: ' ',
          newline_size: 1,
          newline_character: "\n"
        }
      end
      
      def indent(options)
        (options[:indent_char] * options[:indent_size]) * options[:depth]
      end
      
      def newline(options)
        newline_char = options[:newline_size] == 0 ? '; ' : options[:newline_character]
        
        options[:newline_character] * options[:newline_size]
      end
      
      def parse_children(node, options={})
        options = default_options.merge( options )
        
        output = ''
        
        node[:children].each do |node|
          output << indent(options)
          
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
          
          output << newline(options)
          output << parse_children( node, options.merge(depth: options[:depth]+1) ) if node.has_key?(:children)
          
          output << "#{ indent(options) }end#{ newline(options) }" if node.has_key?(:module) || node.has_key?(:class)
        end
        
        output
      end
      
    end
    
  end
end
