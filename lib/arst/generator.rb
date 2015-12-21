module ARST
  # The container module for generator classes.
  module Generator
    class << self
      # Get all known Generator::Base subclasses.
      #
      # @return [Generator::Base]
      def all
        @all ||= {}
      end

      # Invoke a generator.
      #
      # @param [#to_sym] name
      # @param [Node::Base] node
      # @param [#to_h] options
      # @return [Generator::Base]
      def generate(name, node, options={})
        name = name.to_sym
        raise ArgumentError, "unknown generator '#{name}'" unless all.key?(name)

        all[name].generate(node, options)
      end
    end
  end
end

require "arst/generator/arst"
require "arst/generator/ruby"
require "arst/generator/c"
