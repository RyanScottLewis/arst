require 'arst'

require 'ap'
require 'pp'

begin
  puts '', '----- input ----------------------------------------------------------------------', ''
  input = DATA.read
  ap input
  
  puts '', '----- tree -----------------------------------------------------------------------', ''
  tree = ARST::Parser.parse(input)
  ap tree
  
  puts '', '----- output (Ruby, single file) -------------------------------------------------', ''
  output = ARST::Generator::Ruby.generate(tree)
  puts output
  
rescue ARST::Parser::ParseFailed => failure
  puts '', '----- error ----------------------------------------------------------------------', ''
  puts failure.cause.ascii_tree
end

__END__
module StupidModel
  module Validations
  module Callbacks
  module Serialization
    module ClassMethods
    module InstanceMethods
  class Base
    extend Callbacks
    include Validations
    include Serialization
class User < StupidModel::Base