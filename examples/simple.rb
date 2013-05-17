require 'arst'

require 'ap'
require 'pp'

begin
  input = DATA.read
  
  puts '', '----- input ----------------------------------------------------------------------', ''
  ap input
  
  tree = ARST.parse(input)
  
  puts '', '----- tree -----------------------------------------------------------------------', ''
  ap tree
  
rescue ARST::Parser::ParseFailed => failure
  puts '', '----- error ----------------------------------------------------------------------', ''
  puts failure.cause.ascii_tree
end

__END__
module Test
  class Bar
  module Foo
    module Baz
      module Qux
      module NoWai
module UserSystem
  class User
  class Admin < User
