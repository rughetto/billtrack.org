class ApiData < ActiveRecord::Base
  self.abstract_class = true
  establish_connection( Merb::Orms::ActiveRecord.configurations["data_#{Merb.env}".to_sym] )
end
