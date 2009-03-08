class CongressionalSession
  def self.current(opts={})
    if @current.blank? || opts[:reload]
      @current ||= PoliticianIssue.maximum(:session) || 111
    end
    @current  
  end
  
  def self.first
    111
  end
  
  def self.number_of_sessions
    current - first + 1
  end      
end  
  