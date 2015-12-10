module ARST
  module Node
    # Adds the `children` attribute.
    module HasChildren
      def initialize(attributes={})
        @children = []

        super(attributes)
      end

      # Get the children of this keyword.
      attr_reader :children
    end
  end
end
