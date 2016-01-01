module ARST
  module Node
    # The base class for nodes within the syntax tree.
    class Base
      class << self
        # Get the type name.
        def type
          to_s.split(/::/).last.to_sym
        end
      end

      def initialize(attributes={})
        @type = ARST::Helpers.underscore(self.class.to_s.split(/::/).last).to_sym

        update_attributes(attributes)
      end

      # Update the attributes.
      def update_attributes(attributes={})
        return if attributes.nil?

        attributes = attributes.to_h
        attributes.each { |name, value| send("#{name}=", value) }

        attributes
      end

      # Get the parent.
      #
      # @return [nil, Node::Base]
      attr_reader :parent

      # Get the parent.
      #
      # @return [nil, Node::Base]
      def parent=(value)
        raise TypeError unless value.nil? || value.is_a?(Node::Base) # TODO: Error::Node::InvalidNode ?

        @parent = value
      end

      # Get all ancestors.
      #
      # @return [<Node::Base>]
      def ancestors
        return [] if parent.nil?

        (parent.ancestors || []) + [self]
      end

      # Get the type.
      #
      # @return [Symbol]
      attr_reader :type
    end
  end
end
