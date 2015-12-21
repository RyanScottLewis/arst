require "arst/node/has_children"
require "arst/node/keyword"

module ARST
  module Node
    # The node for the `module` keyword.
    class ModuleKeyword < Keyword
      include HasChildren
    end
  end
end
