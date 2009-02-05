class Committee < ActiveRecord::Base
  # RELATIONSHIPS ==================
  has_many :committee_members
  belongs_to :parent, :class_name => "Committee", :foreign_key => "parent_id"
  has_many :children, :class_name => "Committee", :foreign_key => "parent_id"
  has_many :committee_members
  
  def self.batch_import
    Committee.delete_all
    CommitteeMember.delete_all
    
    (Govtracker::Committee.hpricoted/:committee).each do |com|
      committee = find_or_create_by_name( com.get_attribute('displayname') )
      committee.chamber = com.get_attribute('type')
      committee.code = com.get_attribute('code')
      committee.url = com.get_attribute('url')
      committee.save
      
      # add committee members
      committee.import_members( com )
      
      # add subcommittees
      (com/:subcommittee).each do |sub|
        sub_committee = find_or_create_by_name( sub.get_attribute('displayname') )
        sub_committee.code = sub.get_attribute('code')
        sub_committee.import_members( sub )
        sub_committee.parent = committee
        sub_committee.save
      end    
    end
    
    all
  end 
  
  def import_members( hpricot_part )
    (hpricot_part/:member).each do |member|
      govtrack_id = member.get_attribute('id')
      pol = Politician.find_by_govtrack_id( govtrack_id )
      name = member.get_attribute('name')
      role = member.get_attribute('role')
      if cm = CommitteeMember.find_fuzzy(
          :committee_id => self.id,
          :politician => pol,
          :politician_name => name
        )
        cm.role = role
        cm.politician_name = name
        cm.save
      else 
        cm = CommitteeMember.create(
          :committee => self,
          :politician => pol,
          :role => role,
          :politician_name => name
        ) unless pol.nil? && name.blank?
      end  
    end
  end  
  
end
