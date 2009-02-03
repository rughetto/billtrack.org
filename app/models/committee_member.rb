class CommitteeMember < ActiveRecord::Base
  belongs_to :committee
  belongs_to :politician
  
  def self.find_fuzzy(hash)
    com_id =  hash[:committee_id]
    if pol = hash[:politician]
      first( :conditions => {
        :committee_id => com_id,
        :politician_id => pol.id
      })
    else
      first( :conditions => {
        :committee_id => com_id,
        :politician_name => hash[:name]
      })  
    end  
  end
  
end
