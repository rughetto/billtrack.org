class Committee < ActiveRecord::Base
  # RELATIONSHIPS ==================
  has_many    :committee_members
  belongs_to  :parent, :class_name => "Committee", :foreign_key => "parent_id"
  has_many    :children, :class_name => "Committee", :foreign_key => "parent_id"
  has_many    :name_lookups, :as => :parent
  
  def self.govtracker
    @govtracker ||= GovtrackerFile.new(:file => "#{GovtrackerFile.current_session}/committees.xml" )
  end  
  
  def self.batch_import
    (govtracker.parsed_file/:committee).each do |com|
      session = (com/"thomas-names/name").collect {|name_tag| name_tag.get_attribute('session').to_i }.max
      committee = find_or_create_by( :name => com.get_attribute('displayname'), :congressional_session => session )
      committee.chamber = com.get_attribute('type')
      committee.code = com.get_attribute('code')
      committee.url = com.get_attribute('url')
      committee.congressional_session = session
      committee.save
      
      # add committee members
      committee.import_members( com )
      
      # add name lookups
      committee.add_lookups( com/"thomas-names" )
      
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
  
  def import_members( parsed_part )
    (parsed_part/:member).each do |member|
      govtrack_id = member['id'].to_s
      pol = Politician.lookup(:govtrack_id => govtrack_id )
      name = member.get_attribute('name')
      role = member.get_attribute('role')
      if cm = CommitteeMember.find_fuzzy(
          :committee_id => self.id,
          :politician => pol,
          :govtrack_id => govtrack_id
        )
        cm.role = role
        cm.govtrack_id = govtrack_id
        cm.save
      else 
        cm = CommitteeMember.create(
          :committee => self,
          :politician => pol,
          :role => role,
          :govtrack_id => govtrack_id
        ) unless pol.nil? && name.blank?
      end  
    end
  end
  
  def add_lookups( thomas_xml )
    (thomas_xml/:name).each do |xml|
      NameLookup.find_or_create_by(:parent_id => self.id, :parent_type => self.class.to_s, :name => xml.inner_html )
    end  
  end 
  
  def create_lookup( n )
    NameLookup.find_or_create_by(:parent_id => self.id, :parent_type => 'Committee', :name => n )
  end  
  
  def self.lookup( n )
    looker = NameLookup.first( :conditions => ["parent_type = 'Committee' AND name like ?", n ], :include => :parent )
    looker ? looker.parent : nil
  end   
  
end
