class Committee < ApiData
  # RELATIONSHIPS ==================
  has_many    :committee_members
  belongs_to  :parent, :class_name => "Committee", :foreign_key => "parent_id"
  has_many    :children, :class_name => "Committee", :foreign_key => "parent_id"
  
end
