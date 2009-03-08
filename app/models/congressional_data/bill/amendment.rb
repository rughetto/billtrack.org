class Amendment < Bill
  # RELATIONSHIPS ==============================
  belongs_to :bill, :foreign_key => :parent_id
  has_many :sponsors, :through => :bill_sponsors # less picky than in Bill object 

end  