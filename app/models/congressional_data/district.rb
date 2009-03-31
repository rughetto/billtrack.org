class District < ApiData
  # ATTRIBUTES --------------------
  # t.string  :number
  # t.integer :state 
  
  # CACHING -----------------------
  include PoorMansMemecache
  cache_on_keys :state, :number
  
  def state 
    @state ||= State.first(:conditions => {:code => self[:state] })
  end 
   
  def state=( code )  
    if code.class == String   
      self[:state] = code
    elsif code.class == State 
      self[:state] = code.code
    else 
      raise ArgumentError, "must be State object or string identifying code"  
    end    
  end  
  
  has_many :district_maps
  has_many :representatives, :class_name => 'Representative'
  def representative    
    self.representatives.first
  end  
  
  def senators
    @senators ||= Senator.all( :conditions => {:state => self[:state]}, :order => 'seat DESC' )
  end
end  
