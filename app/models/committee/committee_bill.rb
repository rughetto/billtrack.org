class CommitteeBill < ActiveRecord::Base
  belongs_to :committee
  belongs_to :bill
  
  def self.import_set( xml, b )
    set = []
    (xml/:committee).each do |sponsor_xml|
      name = sponsor_xml['name'].to_s
      committee = Committee.find_by(:name => name )
      activity = sponsor_xml['activity']
      attr_hash = { :committee_name => name, :activity => activity }
      if committee
        attr_hash.merge!({ :committee_id => committee.id })
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
