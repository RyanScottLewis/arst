require "arst/node/base"

module ARST
  module Node
    # Adds the `children` attribute.
    module HasChildren
      def initialize(attributes={})
        @children = []
        @children.freeze

        super(attributes)
      end

      # Get the children of this keyword.
      attr_reader :children

      # Add a child.
      #
      # @param [Node::Base] child
      # @return [Node::Base]
      def add_child(child)
        raise TypeError unless child.is_a?(Node::Base) # TODO: Error::Node::InvalidNode ?

        child.parent = self
        @children += [child]
        @children.freeze
      end
    end
  end
end
