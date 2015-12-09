require 'parslet'
require 'arst/node'

module ARST
  
  # The parser for ARST Notation.
  class Parser < Parslet::Parser
    
    class << self
      
      # Parse ARST Notation.
      # 
      # @param [#to_s] input The body of the notation.
      # @return [Node::Root] ARST.
      def parse(input)
        new.parse(input)
      end
      
    end
    
    # Parse ARST Notation.
    #
    # @param [#to_s] input The body of the notation.
    # @return [Node::Root] ARST.
    def parse(input)
      root_node = Node::Root.new
      current_scope = { indentation: 0, node: root_node }
      
      input.lines.each do |line|
        line_tree = super(line)
        
        next unless line_tree.is_a?(Hash)
        
        case line_tree[:type].to_s
        when 'module'
          indentation = line_tree[:indentation].is_a?(Array) ? 0 : line_tree[:indentation].to_s.length
          node = Node::ModuleKeyword.new( name: line_tree[:name] )
          
          # TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          # TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          # TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          # TODO: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          # if indentation < current_scope.indentation
          #   if indentation < current_scope.parent.indentation
          # else
          #
          # end
          
          current_scope.children << node
          current_scope = node
        when 'class'
          indentation = line_tree[:indentation].is_a?(Array) ? 0 : line_tree[:indentation].to_s.length
          node = Node::ClassKeyword.new( name: line_tree[:name], indentation: indentation )
          
          current_scope.children << node
          current_scope = node
        when 'include' then current_scope.children << Node::IncludeKeyword.new( name: line_tree[:name] )
        when 'extend ' then current_scope.children << Node::ExtendKeyword.new( name: line_tree[:name] )
        when 'def'     then current_scope.children << Node::DefKeyword.new( name: line_tree[:name], arguments: line_tree[:arguments] )
        end
      end
      
      root_node
    end
    
    rule(:space)   { match('[\t\s]') }
    rule(:spaces)  { space.repeat(1) }
    rule(:spaces?) { spaces.maybe }
    
    rule(:constant) { match('[A-Z]') >> match('[A-Za-z0-9_]').repeat }
    
    rule(:identifier) { match('[a-z_]') >> match('[A-Za-z0-9_]').repeat }
    
    rule(:namespace) { constant >> ( str('::') >> constant ).repeat(0) } # TODO: A constant which is not a module or class cannot have a ::
    
    rule(:module_keyword) { str('module').as(:type) >> spaces >> namespace.as(:name) }
    
    rule(:class_keyword) { str('class').as(:type) >> spaces >> namespace.as(:name) >> ( spaces >> str('<') >> spaces >> namespace.as(:superclass) ).maybe }
    
    rule(:include_keyword) { str('include').as(:type) >> spaces >> namespace.as(:name) }
    
    rule(:extend_keyword) { str('extend').as(:type) >> spaces >> namespace.as(:name) }
    
    # TODO: Should we have rules for arglists? See: http://kschiess.github.io/parslet/get-started.html
    rule :def_keyword do
      str('def').as(:type) >> space >> identifier.as(:name) >> spaces.maybe >>
      (
        # str('(') >> match('[()\n]').absent?.maybe >> str(')')
        # str('(') >> (match('[)\n]').absent? >> any).repeat >> str(')')
        str('(') >> (str(')').absent? >> any).repeat >> str(')')
      ).as(:arguments).maybe
    end
    
    rule(:keyword) { module_keyword | class_keyword | include_keyword | extend_keyword | def_keyword }
    
    rule(:document) { space.repeat(0).as(:indentation) >> keyword.maybe >> spaces? }
    
    root :document
    
  end
  
end

