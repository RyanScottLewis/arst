require 'parslet' 

module ARST
  
  # The parser for ARST.
  class Parser < Parslet::Parser
    
    def self.parse(input)
      new.parse(input)
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
      str('module') >> spaces >> constant.as(:module)
    end
    
    rule :class_keyword do
      str('class') >> spaces >> constant.as(:class) >>
      (
        spaces >> str('<') >> spaces >> constant.as(:superclass)
      ).maybe
    end
    
    rule :include_keyword do
      str('include') >> space >> constant.as(:include)
    end
    
    rule :extend_keyword do
      str('extend') >> space >> constant.as(:extend)
    end
    
    def node(depth)
      indent(depth) >> 
      (
        ( class_keyword | module_keyword ) >> newline.maybe >>
        (
          dynamic { |soutce, context| node(depth+1).repeat(0) }
        ).as(:children) |
        ( include_keyword | extend_keyword ) >> newline.maybe |
        newline
      )
    end 
    
    rule(:document) { node(0).repeat }
    
    root :document
    
  end
  
end
