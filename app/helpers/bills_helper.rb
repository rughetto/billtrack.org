module Merb
  module BillsHelper
    def issues_text
      has_permissions? ? 'Add' : 'Suggest'
    end  
      
  end
end # Merb