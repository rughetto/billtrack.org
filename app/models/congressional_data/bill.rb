class Bill < ApiData
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
   
  # INSTANCE_METHODS ======================================= 
  # text_helpers -----------
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
