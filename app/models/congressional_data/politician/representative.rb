class Representative < Politician
  def district
    @district ||= District.find_by_id( district_id )
  end  
  def district=( d )
    if d.class == String || d.class == Fixnum
      self.state_id = s.to_s
    elsif s.class = District
      self.state_id = d.id
    else
      raise ArgumentError, "should be State object or a Fixnum identifying the State id"
    end    
    district 
  end  
end  