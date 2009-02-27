class Member < ActiveRecord::Base
  #include Merb::Authentication::Mixins::ActivatedUser
  
  # ATTRIBUTES ===================
  
  
  # RELATIONSHIPS ================
  def state
    @state ||= State.find_by_id(state_id)
  end   
  def state=( s )
    if s.class == String || s.class == Fixnum
      self.state_id = s.to_s
    elsif s.class = State
      self.state_id = s.id
    else
      raise ArgumentError, "should be State object or a Fixnum identifying the State id"
    end    
    state 
  end  
  
  def party
    @party ||= Party.find_by_id(party_id)
  end  
  def party=( p )
    raise ArgumentError, "expected Party object" if p.class != Party
    self.party_id = p.id
  end  
  
end
