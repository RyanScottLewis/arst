require "arst/node/has_children"
require "arst/node/keyword"

module ARST
  module Node
    # The node for the `class` keyword.
    class ClassKeyword < Keyword
      include HasChildren

      # Get the superclass for this instance.
      #
      # @return [nil, String]
      attr_reader :superclass

      # Get whether this class has a superclass.
      #
      # @return [Boolean]
      def superclass?
        !@superclass.nil?
      end

      # Set the superclass for this instance.
      #
      # @param [nil, #to_s] value
      # @return [nil, String]
      def superclass=(value)
        @superclass = if value.nil?
          nil
        else
          value = value.to_s.strip # TODO: Sanitize value given as a namespace node

          value.empty? ? nil : value
        end
      end
    end
  end
end
