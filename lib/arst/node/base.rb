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

        raise TypeError, 'attributes must respond to #to_hash or #to_h' unless attributes.respond_to?(:to_hash) || attributes.respond_to?(:to_h)
        attributes = attributes.to_hash rescue attributes.to_h

        attributes.each { |name, value| send("#{name}=", value) }
      end
    end
  end
end
