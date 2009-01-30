class Senator < Politician
  def districts
    District.all{|rec| rec.state == self.state}
  end  
end