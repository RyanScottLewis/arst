require 'arst/generator/base'

module ARST
  module Generator
    
    class Ruby < Base
      
      protected
      
      # =-=-= Hooks =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      
      def default_options
        {
          depth:             0,
          split_files:       false,
          indent_size:       2,
          indent_char:       ' ',
          newline_size:      1,
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
      
      # =-=-= Parsers =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      
      def parse_children(node, options={})
        options = default_options.merge( options )
        
        if options[:split_files]
          parse_children_as_single_file(node, options)
        else
          parse_children_as_single_file(node, options)
        end
      end
      
      def parse_children_as_single_file(node, options={})
        output = ''
        
        node[:children].each do |node|
          output << indent(options)
          output << code_from_node(node)
          output << newline(options)
          output << parse_children_as_single_file( node, options.merge(depth: options[:depth]+1) ) if node.has_key?(:children)
          output << "#{ indent(options) }end#{ newline(options) }" if node.has_key?(:module) || node.has_key?(:class)
        end
        
        output
      end
      
      def parse_children_as_multiple_files(node, options={})
        output = ''
        
        node[:children].each do |node|
          output << indent(options)
          output << code_from_node(node)
          output << newline(options)
          output << parse_children_as_multiple_files( node, options.merge(depth: options[:depth]+1) ) if node.has_key?(:children)
          output << "#{ indent(options) }end#{ newline(options) }" if node.has_key?(:module) || node.has_key?(:class)
        end
        
        output
      end
      
      # =-=-= Helpers =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      
      # TODO: Should pase as node[:type] instead of :module, :class, etc.
      def code_from_node(node)
        if node[:module]
          "module #{ node[:module] }"
        elsif node[:class]
          code_class = "class #{ node[:class] }"
          code_subclass = " < #{ node[:superclass] }" if node[:superclass]
          
          "#{code_class}#{code_subclass}"
        elsif node[:include]
          "include #{ node[:include] }"
        elsif node[:extend]
          "extend #{ node[:extend] }"
        end
      end
      
    end
    
  end
end
