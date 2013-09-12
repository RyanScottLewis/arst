require 'arst/node'

module ARST
  
  # The transformer for ARST to transform the parsed tree into an AST.
  class Transformer
    
    def self.apply(tree)
      new(tree).apply
    end
    
    def initialize(tree)
      @tree, @root = tree, Node::Root.new
    end
    
    def apply
      transform(@tree)
    end
    
    protected
    
    def transform(node)
      @current_node = node
      node[:children].each do |child|
        newline(options)
        transform(node) if node.has_key?(:children)
      end
    end
    
   end
  
end
