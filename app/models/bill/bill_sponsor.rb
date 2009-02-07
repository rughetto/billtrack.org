class BillSponsor < ActiveRecord::Base
  belongs_to :bill
  belongs_to :politician
  belongs_to :sponsor, :class_name => "Politician"
end
