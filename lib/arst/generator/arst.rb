require "arst/generator/base"
require "arst/node"

module ARST
  module Generator
    # The ARST Syntax generator.
    class ARST < Base
      protected

      def default_options
        {
          depth:       0,
          split_files: true,
          indent_size: 2,
          indent_char: " "
        }
      end

      def parse_children(node, options={})
        options = default_options.merge(options.to_h)
        output = ""

        node.children.each do |child|
          output << (options[:indent_char] * options[:indent_size]) * options[:depth]

          output << case child
            when Node::ModuleKeyword then "module #{child.name}"
            when Node::ClassKeyword then "class #{child.name}#{" < #{child.superclass}" if child.superclass?}"
            when Node::IncludeKeyword then "include #{child.name}"
            when Node::ExtendKeyword then "extend #{child.name}"
          end

          output << "\n"
          output << parse_children(child, options.merge(depth: options[:depth] + 1)) if child.respond_to?(:children)
        end

        output
      end
    end
  end
end
