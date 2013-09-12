require 'arst'

require 'ap'
require 'pp'
require 'pry'

begin
  puts '', 'INPUT', ''
  input = DATA.read
  puts input
  
  puts '', 'PARSED', ''
  tree = ARST::Parser.parse(input)
  ap tree
  
  # pry
  
  options = { indent_char: "  ", indent_size: 1 }
  puts '', "OUTPUT - Ruby, single file, options=#{options}", ''
  output = ARST::Generator::Ruby.generate(tree, options)
  puts output
  
rescue ARST::Parser::ParseFailed => failure
  puts '', 'ERROR', ''
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
module StupidRecord
  module Persistence
  class Base < StupidModel::Base
    include Persistence