class CommitteeMember < ActiveRecord::Base
  belongs_to :committee
  belongs_to :politician
  
  def self.find_fuzzy(hash)
    com_id =  hash[:committee_id]
    if hash[:politician]
      first( :conditions => {
        :committee_id => com_id,
        :politician_id => hash[:politician].id
      })
    else
      first( :conditions => {
        :committee_id => com_id,
        :govtrack_id => hash[:govtrack_id]
      })  
    end  
  end
  
  def self.find_missing_politicians
    all(:conditions => {:politician_id => nil}).each do |record|
      xml =  Politician.govtracker.search(:id => record.govtrack_id )
      xml = xml.first
      bioguide_id = xml['bioguideid'].to_s
      pol = Politician.lookup(:bioguide_id => bioguide_id)
      pol = Politician.name_lookup( "#{xml['firstname']} #{xml['lastname']}" ) unless pol
      if pol
        # update record
        record.politician_id = pol.id
        record.save
        # add id lookup
        pol.create_lookup(:govtrack_id => record.govtrack_id)
      end  
    end
  end  
  
end
