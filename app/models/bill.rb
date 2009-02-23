class Bill < ActiveRecord::Base
  # ATTRIBUTES ===========================================
    # t.string   "type" # STI
    # t.string   "congressional_session"
    # t.string   "chamber"
    # t.string   "number"
    # t.string   "sequence"
    # t.integer  "parent_id"
    # t.string    :parent_name # in case unable to find parent
    # t.datetime "introduced_at"
    # t.string   "short_title"
    # t.text     "title"
    # t.datetime "xml_updated_at"
  
  # VALIDATIONS ==========================================
  validates_presence_of :congressional_session, :chamber, :number
  
  # RELATIONSHIPS ========================================
  has_many :actions,              :class_name => "BillAction"
  has_many :statuses,             :class_name => "BillStatus"
  has_many :bill_subjects
  has_many :legislative_issues,   :through => :bill_subjects
  has_many :committee_bills
  has_many :committees,           :through => :committee_bills
  has_many :amendments,           :class_name => "Bill",      :foreign_key => :parent_id 
  has_many :bill_sponsors
  has_many :sponsors,             :through => :bill_sponsors, :conditions => 'ISNULL( bill_sponsors.type )'
  has_many :cosponsors,           :through => :bill_sponsors, :conditions => 'bill_sponsors.type = "BillCoSponsor"', :source => :sponsor  
  has_many :relateds,             :class_name => "RelatedBill"
  has_many :related_bills,        :through => :relateds
   
  
  # IMPORTS =============================================
  def self.govtracker
    @govtracker ||= GovtrackerFileSet.new(:dir => "#{GovtrackerFileSet.current_session}/bills", :tag => "bill")
  end  
  
  def self.import_set
    set = [import_data( govtracker.current.parsed_file )]
    while govtracker_file = govtracker.next
      set << import_data( govtracker_file.parsed_file )
    end 
    set 
  end
  
  def self.import_data( xml )
    xml = (xml/govtracker.tag).first
    bill = find_or_create_from( xml )
    
    # import methods particular to class, bill vs amendment
    introduced_at = (xml/"introduced").first['date']
    bill.introduced_at = Time.at(introduced_at.to_i)
    
    (xml/"title").each do |title_xml|
      if bill.short_title.blank? && title_xml['type'] == 'short' && title_xml['as'] == 'introduced'
        bill.short_title = title_xml.inner_html
      elsif bill.title.blank? && title_xml['type'] == 'official' && title_xml['as'] == 'introduced'
        bill.title = title_xml.inner_html
      end     
      break unless bill.short_title.blank? || bill.title.blank?
    end  
    
    bill.save
    bill.bill_sponsors <<   BillCoSponsor.import_set( xml, bill )
    bill.committee_bills << CommitteeBill.import_set( xml, bill )
    bill.bill_subjects <<   BillSubject.import_set( xml/"subjects", bill )
    bill.amendments <<      extract_amendments( xml/"amendments")
    bill.relateds <<        RelatedBill.import_set( xml/'relatedbills', bill )
    
    bill.save
    bill
  end
  
  private
    def self.find_or_create_from( xml )
      # common attributes
      attrs = xml.attributes
      chamber = attrs["chamber"] || attrs["type"]
      type = self == Bill ? nil : 'Amendment'
      bill = find_or_create_by( 
        :congressional_session => attrs["session"].to_s, 
        :chamber => chamber.to_s,
        :number => attrs["number"].to_s,
        :type => type
      )
      xml_updated_at = attrs["updated"].to_s
      bill.xml_updated_at = Time.parse(xml_updated_at)
      
      # relationships
      bill.actions << action_set =   BillAction.import_set(xml/"actions", bill)
      status_set = BillStatus.import_set(xml/"status", bill)
      status_set = BillStatus.import_set(xml, bill) if status_set.blank?
      bill.statuses << status_set
      bill.bill_sponsors << BillSponsor.import_set( xml, bill )
      
      bill
    end  
    
    def self.extract_amendments( xml )
      set = []
      (xml/'amendment').each do |a_xml|
        str = a_xml['number'].to_s
        number = str.match(/\d*$/).to_s
        chamber = str.gsub(number, '')
        set << Amendment.find_by(:chamber => chamber, :number => number)
      end 
      set 
    end
      
  public 
     
  def title_short
    short_title.blank? ? title : short_title
  end     
  
  def id_number
    "#{split_chamber} #{number}"
  end
  
  def split_chamber
    str = ''
    chamber.each_char{|char| str << char.upcase + '.'}
    str
  end     
   
end
