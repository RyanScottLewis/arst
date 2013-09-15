require 'arst/generator/base'

module ARST
  module Generator
    
    # TODO: This class is so dirty >=) CLEANN EEETTT
    class Ruby < Base
      
      def initialize(node)
        super(node)
        
        @current_output = nil
      end
      
      protected
      
      # =-=-= Hooks =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      
      def default_options
        {
          depth:             0,
          split_files:       true,
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
          @current_output = []
          parse_children_as_multiple_files(node, options)
        else
          @current_output = [ { filename: filename_for_single_file(node), body: '' } ]
          
          parse_children_as_single_file(node, options)
        end
        
        result = @current_output
        @current_output = nil
        
        result
      end
      
      def parse_children_as_single_file(node, options={})
        node.children.each do |node|
          @current_output[0][:body] << indent(options)      # TODO: DRY this up as a helper method
          @current_output[0][:body] << code_from_node(node) # TODO: DRY this up as a helper method
          @current_output[0][:body] << newline(options)     # TODO: DRY this up as a helper method
          parse_children_as_single_file( node, options.merge(depth: options[:depth]+1) ) unless node.children.empty?
          @current_output[0][:body] << "#{ indent(options) }end#{ newline(options) }" if [:module, :class].include?(node.type)
        end
      end
      
      def parse_children_as_multiple_files(node, options={})
        options[:ancestors] = node.ancestors # The main (first) node's ancestor list
        
        unless [:root, :include, :extend].include?(node.type) # TODO: Hold container (class, module) and non-container (include, extend) in helper method or constant
          @current_output << { filename: filename_for_split_files(node), body: parse_node_for_multiple_files(node, options) }
        end
        node.children.each { |child| parse_children_as_multiple_files(child, options) }
      end
      
      def parse_node_for_multiple_files(node, options={})
        output = ''
        options[:current_ancestor_index] ||= 0
        ancestor = options[:ancestors][ options[:current_ancestor_index] ]
        
        output << indent(options)          # TODO: DRY this up as a helper method
        output << code_from_node(ancestor) # TODO: DRY this up as a helper method
        output << newline(options)         # TODO: DRY this up as a helper method
        
        if options[:current_ancestor_index] == options[:ancestors].count - 1 # The first node
          child_options = options.merge(depth: options[:depth]+1)
          
          ancestor.children.each do |child|
            if [:include, :extend].include?(child.type) # TODO: Hold container (class, module) and non-container (include, extend) in helper method or constant
              output << indent(child_options)          # TODO: DRY this up as a helper method
              output << code_from_node(child)          # TODO: DRY this up as a helper method
              output << newline(child_options)         # TODO: DRY this up as a helper method
            end
          end
        else
          child_options = options.merge(depth: options[:depth]+1, current_ancestor_index: options[:current_ancestor_index]+1)
          output << parse_node_for_multiple_files( ancestor, child_options )
        end
        
        output << "#{ indent(options) }end#{ newline(options) }" if [:module, :class].include?(ancestor.type)
        
        output
      end
      
      # =-=-= Helpers =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
      
      def filename_for_single_file(node)
        node.children.collect(&:human_name).join('_and_') + '.rb'
      end
      
      def filename_for_split_files(node)
        node.ancestors.collect(&:human_name).join('/') + '.rb'
      end
      
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
