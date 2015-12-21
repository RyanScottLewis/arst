require "arst/helpers"
require "arst/node/base"

module ARST
  module Node
    # The base class for keyword nodes within the syntax tree.
    class Keyword < Base
      # Get the parent of this keyword.
      #
      # @return [Node::Base]
      attr_reader :parent

      # Get the name of this keyword.
      #
      # @return [String]
      attr_reader :name

      # Set the name of this keyword.
      #
      # @param [#to_s] value
      # @return [String]
      def name=(value)
        @name = value.to_s.strip
      end

      # Get the human readable name of this keyword.
      #
      # @return [String]
      def human_name
        Helpers.underscore(@name)
      end

      # Get the type of this keyword.
      #
      # @return [Symbol]
      attr_reader :type

      # Set the type of this keyword.
      #
      # @param [#to_sym] value
      # @return [Symbol]
      def type=(value)
        @type = value.to_sym
      end
    end
  end
end
