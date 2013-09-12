require 'arst/generator/base'

module ARST
  module Generator
    
    class Ruby < Base
      
      protected
      
      # =-=-= Hooks =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      
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
      
      # =-=-= Parsers =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      
      def parse_children(node, options={})
        options = default_options.merge( options )
        
        if options[:split_files]
          parse_children_as_multiple_files(node, options)
        else
          parse_children_as_single_file(node, options)
        end
      end
      
      def parse_children_as_single_file(node, options={})
        output = ''
        
        node.children.each do |node|
          output << indent(options)
          output << code_from_node(node)
          output << newline(options)
          output << parse_children_as_single_file( node, options.merge(depth: options[:depth]+1) ) unless node.children.empty?
          output << "#{ indent(options) }end#{ newline(options) }" if [:module, :class].include?(node.type)
        end
        
        output
      end
      
      def parse_children_as_multiple_files(node, options={})
        output = ''
        
        node.children.each do |node|
          output << indent(options)
          output << code_from_node(node)
          output << newline(options)
          output << parse_children_as_multiple_files( node, options.merge(depth: options[:depth]+1) ) unless node.children.empty?
          output << "#{ indent(options) }end#{ newline(options) }" if [:module, :class].include?(node.type)
        end
        
        output
      end
      
      # =-=-= Helpers =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      
      def code_from_node(node)
        case node.type
        when :module
          "module #{ node.name }"
        when :class
          code_class = "class #{ node.name }"
          code_subclass = " < #{ node.superclass }" if node.superclass
          
          "#{code_class}#{code_subclass}"
        when :extend
          "extend #{ node.name }"
        when :include
          "include #{ node.name }"
        else
          ""
          # TODO: Raise ARST::Error::InvalidNodeType
        end
      end
      
    end
    
  end
end
