class BillSponsor < ActiveRecord::Base
  belongs_to :bill
  belongs_to :politician
  belongs_to :sponsor, :class_name => "Politician", :foreign_key => 'politician_id'
  
  def self.import_set( xml, b )
    set = []
    (xml/tag).each do |sponsor_xml|
      politician = Politician.lookup(:govtrack_id => sponsor_xml['id'].to_s )
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
  
  def self.find_missing_politicians
    all(:conditions => {:politician_id => nil}).each do |record|
      xml =  Politician.govtracker.search(:id => record.govtrack_id )
      xml = xml.first
      bioguide_id = xml['bioguideid'].to_s
      pol = Politician.lookup(:bioguide_id => bioguide_id)
      pol = Politician.name_lookup( "#{xml['firstname']} #{xml['lastname']}" ) unless pol
      if pol
        # update record
        record.politician_id = pol.id
        record.save
        # add id lookup
        pol.create_lookup(:govtrack_id => record.govtrack_id)
      end  
    end  
  end  
end
