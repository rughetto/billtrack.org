class Senator < Politician
  def districts
    District.all_by_state(self[:state])
  end  
end