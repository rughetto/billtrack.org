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
  
  # IMPORTS =============================================
  def self.govtracker
    GovtrackerFileSet.new(:dir => '111/bills', :tag => "bill")
  end  
  
  def self.batch_import
    import_data( govtracker.current )
    while file_data = govtracker.next
      import_data( file_data )
    end  
  end
  
  def self.import_data
  end
end
