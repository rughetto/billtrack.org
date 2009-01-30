class Zipcode
  attr_accessor :zip, :errors, :main, :plus_four
  
  def initialize(str)
    @zip = str
  end  
  
  def parse
    if valid?
      parts = self.zip.match(/(\d{5})-?(\d{4})?/).captures
      self.main = parts[0] 
      self.plus_four = parts[1]
    else
      self.main = nil
      self.plus_four = nil  
    end
    [self.main, self.plus_four]   
  end  
  
  def valid?
    if self.zip.match(/(^\d{5}$)|(^\d{5}-\d{4}$)/)
      self.errors = nil
      return true
    else
      self.errors = "not a valid zipcode format"
      return false
    end    
  end
  
  def to_s
    parts = parse
    if parts.first.nil?
      nil
    elsif parts.last.nil? 
      self.main
    else  
      "#{self.main}-#{self.plus_four}"
    end  
  end 
  
  class AccessError; end   
end  