module ARST
  module Node
    # The base class for nodes within the syntax tree.
    class Base
      class << self
        # Get the type name for this node.
        def type
          to_s.split(/::/).last.to_sym
        end
      end

      def initialize(attributes={})
        update_attributes(attributes)
      end

      # Update the attributes on this node.
      def update_attributes(attributes={})
        return if attributes.nil?

        attributes = attributes.to_h
        attributes.each { |name, value| send("#{name}=", value) }

        attributes
      end

      # Get the parent of this node.
      #
      # @return [nil, Node::Base]
      attr_reader :parent

      # Get the parent of this node.
      #
      # @return [nil, Node::Base]
      def parent=(value)
        raise TypeError unless value.nil? || value.is_a?(Node::Base) # TODO: Error::Node::InvalidNode ?

        @parent = value
      end
    end
  end
end
