require "arst/generator"
require "arst/helpers"

module ARST
  module Generator
    class Base
      class << self
        def inherited(subclass)
          Generator.all[subclass.name] = subclass
        end

        def generate(node, options={})
          new(node).generate(options)
        end

        def name
          @name ||= Helpers.underscore(to_s.split(/::/).last).to_sym
        end
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
