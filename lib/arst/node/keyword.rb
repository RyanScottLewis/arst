require "arst/node/base"

module ARST
  module Node
    # The base class for keyword nodes within the syntax tree.
    class Keyword < Base
      # Get the parent of this keyword.
      attr_reader :parent

      # Get the name of this keyword.
      attr_reader :name

      # Set the name of this keyword.
      def name=(name)
        @name = name.to_s.strip # TODO: Sanitize
      end
    end
  end
end
