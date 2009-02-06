class LivRelationship < ActiveRecord::Base
  # RELATIONSHIPS ------------------------
  belongs_to :parent, :class_name => "LegislativeIssue", :foreign_key => "parent_id"
  belongs_to :child, :class_name => "LegislativeIssue", :foreign_key => "child_id"
  
  def self.govtracker
    @govtracker ||= GovtrackerFile.new(:file => 'liv.xml' )
  end
  
  def self.batch_import
    (govtracker.parsed_file/"top-term").each do |top_term|
      parent = LegislativeIssue.find_or_create_by_name( top_term.get_attribute('value') )
      LivRelationship.create( :parent_id => nil, :child_id => parent.id )
      (top_term/:term).each do |tag|
        child = LegislativeIssue.find_or_create_by_name( tag.get_attribute('value'))
        unless parent == child
          LivRelationship.create( :child_id => child.id, :parent_id => parent.id) unless parent == child
          remove = LivRelationship.first(:conditions => {:parent_id => nil, :child_id => child.id })
          LivRelationship.delete( remove.id ) if remove 
        end  
      end  
    end
  end
    
end
