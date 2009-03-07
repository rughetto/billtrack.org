class CongressionalSession
  def self.current
    @current ||= PoliticianIssue.maximum(:session) || 111
  end
  
  def self.first
    111
  end
  
  def self.number_of_sessions
    current - first + 1
  end      
end  
  