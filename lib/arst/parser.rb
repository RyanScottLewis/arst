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
    # rule(:newline) { match('\n') }
    rule(:newline) { str("\n") }
    
    rule :constant do
      match('[A-Z]') >> match('[A-Za-z0-9]').repeat(1)
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
    
    rule :keyword do
      (class_keyword | module_keyword)#.as(:identifier)
    end
    
    def node(depth)
      indent(depth) >> 
      (
        keyword >> newline.maybe >> 
        (
          dynamic { |soutce, context| node(depth+1).repeat(0) }
        ).as(:children) | newline
      )
    end 
    
    rule(:document) { node(0).repeat }
    
    root :document
    
  end
  
end
