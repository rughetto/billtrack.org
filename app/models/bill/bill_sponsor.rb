class BillSponsor < ActiveRecord::Base
  belongs_to :bill
  belongs_to :politician
  belongs_to :sponsor, :class_name => "Politician"
  
  def self.import_set( xml, b )
    set = []
    (xml/tag).each do |sponsor_xml|
      politician = Politician.find_by(:govtrack_id => sponsor_xml['id'].to_s)
      joined_on = sponsor_xml['joined']
      
      attr_hash = { :govtrack_id => sponsor_xml['id'].to_s }
      if joined_on
        joined_on = Time.parse( joined_on.to_s )
        attr_hash.merge!({ :joined_on => joined_on })
      end  
      if politician
        attr_hash.merge!({ :politician_id => politician.id })
      end
      if b.id
        attr_hash.merge!({ :bill_id => b.id })
      end  
      set << find_or_create_by( attr_hash )  
    end
    set
  end  
  
  private
    def self.tag
      self == BillSponsor ? :sponsor : :cosponsor
    end  
  public  
end
