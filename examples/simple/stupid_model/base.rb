require 'stupid_model/base/callbacks'
require 'stupid_model/base/validations'
require 'stupid_model/base/serialization'

module StupidModel
  class Base
    extend Callbacks
    include Validations
    include Serialization
  end
end
