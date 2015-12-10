module ARST
  module Generator
    class Base
      def self.generate(node, options={})
        new(node).generate(options)
      end

      attr_reader :node

      def initialize(node)
        @node = node
      end

      def generate(options={})
        parse_children(@node, options)
      end

      protected

      def parse_children(_node, _options={})
        raise NotImplementedError
      end
    end
  end
end
