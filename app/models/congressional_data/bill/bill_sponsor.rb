class BillSponsor < ApiData
  belongs_to :bill
  belongs_to :politician
  belongs_to :sponsor, :class_name => "Politician", :foreign_key => 'politician_id'
  
end
