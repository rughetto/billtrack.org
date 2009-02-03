class GovtrackerObject
  def self.file
    @file 
  end  
  
  def self.file=( loc )
    @file = File.read( loc )
  end
  
  def self.hpricoted
    Hpricot.parse( file )
  end
  
  def self.search(hash)
    hash = parse_hash( hash )
    hash[:hpricoted].search("//#{hash[:tag]}[@#{hash[:attribute]}='#{hash[:value]}']")
  end
  
  private
    def self.parse_hash( hash )
      hpr = hash.delete(:hpricoted)
      raise ArgumentError, "Hash size must be less than two" unless hash.size == 1
      key = hash.keys.first
      val = hash.values.first
      if val.class == Hash
        local_tag = key
        key = val.keys.first
        val = val.values.first
        raise ArgumentError, "Hash can only be nested one level deep" if val.class == Hash
      else
        local_tag = self.tag
      end    
      {
        :tag => local_tag,
        :attribute => key,
        :value => val,
        :hpricoted => hpr || self.hpricoted
      }  
    end
  public    
    
end

module Govtracker
  
  class People < GovtrackerObject
    def self.file
      @file ||= File.read("#{Merb.root}/schema/govtrack_us/people.xml")
    end  
  
    def self.tag
      'person'
    end  
  end 
  
  class Committee < GovtrackerObject
    def self.file 
      @file ||= File.read("#{Merb.root}/schema/govtrack_us/111/committees.xml")
    end
    
    def self.tag
      'committee'
    end    
  end   
  
  class LegislativeIssue < GovtrackerObject
    def self.file
      @file ||= File.read("#{Merb.root}/schema/govtrack_us/people.xml")
    end  
  
    def self.tag
      'term'
    end
  end  
  
end