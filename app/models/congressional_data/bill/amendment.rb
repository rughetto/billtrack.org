class Amendment < ApiData
  # RELATIONSHIPS ==============================
  belongs_to :bill, :foreign_key => :parent_id
  has_many :statuses, :class_name => "BillStatus"
  has_many :actions, :class_name => "BillAction"
  has_many :bill_sponsors
  has_many :sponsors, :through => :bill_sponsor
  

end  