require 'stupid_model/base'
require 'stupid_model/stupid_record/base/persistence'
require 'stupid_model/optional_methods'

module StupidModel
  module StupidRecord
    class Base < StupidModel::Base
      include Persistence
      include StupidModel::OptionalMethods
    end
  end
end
