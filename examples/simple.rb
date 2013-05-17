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