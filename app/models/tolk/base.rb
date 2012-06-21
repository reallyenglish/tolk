module Tolk
  class Base < ActiveRecord::Base
    self.abstract_class = true
    establish_connection(Tolk::Config.database_config)

  end
end
