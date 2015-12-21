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

        node.children.each do |node|
          output << (options[:indent_char] * options[:indent_size]) * options[:depth]

          output << case node
            when Node::ModuleKeyword then "module #{node.name}"
            when Node::ClassKeyword then "class #{node.name}#{" < #{node.superclass}" if node.superclass?}"
            when Node::IncludeKeyword then "include #{node.name}"
            when Node::ExtendKeyword then "extend #{node.name}"
          end

          output << "\n"
          output << parse_children(node, options.merge(depth: options[:depth] + 1)) if node.respond_to?(:children)
        end

        output
      end
    end
  end
end
