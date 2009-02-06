class LegislativeIssue < ActiveRecord::Base
  # VALIDATIONS ---------------
  validates_uniqueness_of :name
  
  # RELATIONSHIPS -------------
  has_many :parent_relationships, :foreign_key => :child_id, :class_name => "LivRelationship"
  has_many :child_relationships, :foreign_key => :parent_id, :class_name => "LivRelationship"
  has_many :parents, :through => :parent_relationships
  has_many :children, :through => :child_relationships
  
  def parent
    parents.first
  end  
  
  def has_children?
    children.count > 0 ? true : false
  end 
  
  def self.roots
    find_by_sql(" 
    SELECT legislative_issues.*
    FROM legislative_issues, liv_relationships
    WHERE 
      liv_relationships.child_id = legislative_issues.id AND
      ISNULL(liv_relationships.parent_id)
    ")  
  end  
  
  
  # IMPORTS -------------------
  def self.batch_import
    LivRelationship.batch_import
  end

end
