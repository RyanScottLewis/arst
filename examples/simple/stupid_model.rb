module StupidModel
  module Validations
  end
  module Callbacks
  end
  module Serialization
    module ClassMethods
    end
    module InstanceMethods
    end
  end
  module OptionalMethods
  end
  class Base
    extend Callbacks
    include Validations
    include Serialization
  end
  module StupidRecord
    module Persistence
    end
    class Base < Base
      include Persistence
      include StupidModel::OptionalMethods
    end
  end
end
