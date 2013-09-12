require 'parslet'

module ARST
  
  # The parser for ARST.
  class Parser < Parslet::Parser
    
    def self.parse(input)
      new.parse(input)
    end
    
    def parse(input)
      tree = super(input)
      
      Node::Root.new(tree)
    end
    
    def indent(depth)
      str('  ' * depth)
    end
    
    rule(:space)   { match('[\t\s]') }
    rule(:spaces)  { space.repeat(1) }
    rule(:newline) { match('\n') }
    
    rule :constant do
      match('[A-Z]') >> ( match('[A-Za-z0-9]') | str('::') ).repeat(1) # TODO: Cannot end with '::'
    end
    
    rule :module_keyword do
      str('module').as(:type) >> spaces >> constant.as(:name)
    end
    
    rule :class_keyword do
      str('class').as(:type) >> spaces >> constant.as(:name) >>
      ( spaces >> str('<') >> spaces >> constant.as(:superclass) ).maybe
    end
    
    rule :include_keyword do
      str('include').as(:type) >> space >> constant.as(:name)
    end
    
    rule :extend_keyword do
      str('extend').as(:type) >> space >> constant.as(:name)
    end
    
    def node(depth)
      indent(depth) >> 
      (
        ( class_keyword | module_keyword ) >> newline.maybe >>
        dynamic { |soutce, context| node(depth+1).repeat(0) }.as(:children) |
        ( include_keyword | extend_keyword ) >> newline.maybe |
        newline
      )
    end 
    
    rule(:document) { node(0).repeat.as(:children) }
    
    root :document
    
  end
  
end
