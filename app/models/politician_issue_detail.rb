# this whole model is a database shortcut to statistics about the bill_issues
# it should be able to be deleted and recalculated at will. It should also be
# dynamic and tied into BillIssue creation and deletion. Each record has is 
# dependent on a politician, session and an issue. Its parent class is the 
# furter distilled calculation that is not dependent only on Politicians and
# Issues.
class PoliticianIssueDetail < PoliticianIssue
  # ATTIRBUTES ===========================
    # t.integer :politician_id
    # t.integer :issue_id
    # t.string  :type
    # t.integer :issue_count, :default => 0
    # t.integer :score,       :default => 0
    # t.string  :politician_role
    # t.integer :session
  
  # VALIDATIONS ==========================
  validates_presence_of :session
  
  # HOOKS ================================
  before_save :calculate_score
  
  # ISSUE SCORING/RATING ========================
  # If an issue link is not related to a current session then it should be worth less than current issues
  def issue_count
    self[:issue_count] ||= 0
  end  
  
  def increment_count
    self.issue_count += 1
  end  
  
  def calculate_score
    combined_score = issue_score * session_score * sponsor_score
    self.score = combined_score < 1 ? 1.0 : combined_score
  end
  
  def max_issue_count_for_politician
    [ self.class.maximum( :issue_count, :conditions => {:politician_id => self.politician_id} ) || 1, issue_count || 0].max
  end  
  
  # should be from 1 to 10 
  def issue_score
    ic = ( issue_count.to_f / max_issue_count_for_politician.to_f ) * 10
    ic < 1 ? 1.0 : ic
  end  
  
  # a fraction of 1 or 1, not zero
  # if two total sessions then values are 1/2 and 1
  # if three total sessions then values are 1/3, 2/3, 1
  # etc ... 
  def session_score
    (session.to_f - CongressionalSession.first + 1) /
    ( CongressionalSession.number_of_sessions.to_f ) 
  end  
  
  # should be either 1/2 or 1
  def sponsor_score
    politician_role == "Sponsor" ? 1.0 : 0.5
  end 
  
  
  # CLASS METHODS ================================
  
  # class method to add from BillIssue on creation
  def self.add(hash)
    added = find_or_initialize_by( hash )
    added.increment_count
    added
  end  
end
