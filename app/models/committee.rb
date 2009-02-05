class Committee < ActiveRecord::Base
  # RELATIONSHIPS ==================
  has_many :committee_members
  belongs_to :parent, :class_name => "Committee", :foreign_key => "parent_id"
  has_many :children, :class_name => "Committee", :foreign_key => "parent_id"
  
  def self.govtracker
    @govtracker ||= GovtrackerFile.new(:file => "#{GovtrackerFile.current_session}/committees.xml" )
  end  
  
  def self.batch_import
    (govtracker.hpricoted/:committee).each do |com|
      session = (com/"thomas-names/name").collect {|name_tag| name_tag.get_attribute('session').to_i }.max
      committee = find_or_create_by( :name => com.get_attribute('displayname'), :congressional_session => session )
      committee.chamber = com.get_attribute('type')
      committee.code = com.get_attribute('code')
      committee.url = com.get_attribute('url')
      committee.congressional_session = session
      committee.save
      
      # add committee members
      committee.import_members( com )
      
      # add subcommittees
      (com/:subcommittee).each do |sub|
        sub_committee = find_or_create_by( :name => sub.get_attribute('displayname'), :congressional_session => session )
        sub_committee.chamber = committee.chamber
        sub_committee.congressional_session = session
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
  
  def self.find_by( hash )
    first(:conditions => hash )
  end  
  
  def self.find_or_create_by( hash )
    find_by( hash ) || create( hash )
  end  
  
end
