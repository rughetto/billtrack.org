class LivRelationship < ApiData
  # RELATIONSHIPS ------------------------
  belongs_to :parent, :class_name => "LegislativeIssue", :foreign_key => "parent_id"
  belongs_to :child, :class_name => "LegislativeIssue", :foreign_key => "child_id"
  
end
