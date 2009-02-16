class BillSubject < ActiveRecord::Base
  belongs_to :bill
  belongs_to :legislative_issue
  
  def self.import_set( xml, b )
    set = []
    (xml/'term').each do |subject_xml|
      liv = LegislativeIssue.find_or_create_by(:name => subject_xml['name'].to_s)
      attr_hash = { :legislative_issue_id => liv.id }
      if b.id
        attr_hash.merge!({ :bill_id => b.id })
      end  
      set << find_or_create_by( attr_hash )  
    end
    set
  end
end
