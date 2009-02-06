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
        :politician_name => hash[:politician_name]
      })  
    end  
  end
  
end
