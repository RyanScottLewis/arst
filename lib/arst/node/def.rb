require 'arst/node/base'
require 'arst/node/namable'

module ARST
  module Node
    
    class Def < Base
      
      include Namable
      
      attr_accessor :arguments
      
    end
    
  end
end
