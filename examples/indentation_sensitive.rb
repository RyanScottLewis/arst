require 'parslet'

# class IndentationSensitiveParser < Parslet::Parser
#   
#   rule(:indent) { str('  ') }
#   rule(:newline) { str("\n") }
#   rule(:identifier) { match['A-Za-z0-9'].repeat.as(:identifier) }
#   
#   rule(:node) { identifier >> newline >> (indent >> identifier >> newline.maybe).repeat.as(:children) }
#   
#   rule(:document) { node.repeat }
#   
#   root :document
#   
# end

# class IndentationSensitiveParser < Parslet::Parser
#   
#   def initialize
#     @indentation_size
#   end
#   
#   rule(:space) { str(' ') }
#   rule(:indent) { str('  ') }
#   rule(:newline) { str("\n") }
#   rule(:identifier) { match['A-Za-z0-9'].repeat.as(:identifier) }
#   
#   rule(:node) { identifier >> newline >> (indent >> identifier >> newline.maybe).repeat.as(:children) }
#   
#   rule(:document) { node.repeat }
#   
#   root :document
#   
# end

class IndentationSensitiveParser < Parslet::Parser

  def indent(depth)
    str('  ' * depth)
  end
  
  rule(:newline) { str("\n") }
  
  rule(:identifier) { match['A-Za-z0-9'].repeat(1).as(:identifier) }
  
  def node(depth)
    indent(depth) >> identifier >> newline.maybe >> 
    (
      dynamic { |soutce, context| node(depth+1).repeat(0) }
    ).as(:children)
  end 
  
  rule(:document) { node(0).repeat }
  
  root :document
end

require 'ap'
require 'pp'

begin
  input = DATA.read
  
  puts '', '----- input ----------------------------------------------------------------------', ''
  ap input
  
  tree = IndentationSensitiveParser.new.parse(input)
  
  puts '', '----- tree -----------------------------------------------------------------------', ''
  pp tree
  
rescue IndentationSensitiveParser::ParseFailed => failure
  puts '', '----- error ----------------------------------------------------------------------', ''
  puts failure.cause.ascii_tree
end

__END__
level0child0
level0child1
  level1child0
  level1child1
    level2child0
  level1child2
level0child3
