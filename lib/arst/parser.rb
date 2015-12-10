require 'parslet'
require 'arst/node'

module ARST
  
  # The parser for ARST.
  class Parser < Parslet::Parser
    
    def self.parse(input, options={})
      new.parse(input, options)
    end
    
    def parse(input, options={})
      tree = super(input)
      
      options[:raw] ? tree : Node::Root.new(tree)
    end
    
    def indent(depth)
      str('  ' * depth)
    end
    
    rule(:space)   { match('[\t\s]') }
    rule(:spaces)  { space.repeat(1) }
    rule(:newline) { match('\n') }
    
    rule :constant do
      match('[A-Z]') >> ( match('[A-Za-z0-9_]') | str('::') ).repeat(1) # TODO: Cannot end with '::'
    end
    
    rule :identifier do
      match('[a-z_]') >> match('[A-Za-z0-9_]').repeat(1)
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
    
    # TODO: Should we have rules for arglists? See: http://kschiess.github.io/parslet/get-started.html
    rule :def_keyword do
      str('def').as(:type) >> space >> identifier.as(:name) >> spaces.maybe >>
      (
        str('(') >> match('[()\n]').absent? >> str(')')
      ).as(:arguments).maybe
    end
    
    def node(depth)
      indent(depth) >> 
      (
        ( class_keyword | module_keyword ) >> newline.maybe >>
        dynamic { |source, context| node(depth+1).repeat(0) }.as(:children) |
        ( include_keyword | extend_keyword | def_keyword ) >> newline.maybe |
        newline
      )
    end 
    
    rule(:document) { node(0).repeat.as(:children) }
    
    root :document
    
  end
  
end
