class Issue < ActiveRecord::Base
  # ATTRIBUTES =================
  # t.string  :name
  # t.string  :status
  # t.string  :stance_positive
  # t.string  :stance_negative
  # t.integer :parent_id
  # t.integer :lft
  # t.integer :rgt
  # t.integer :suggested_by
  
  # RELATIONSHIPS ==============
  has_many :bill_issues
  has_and_belongs_to_many :bills, :select => "bills.*",
                          :join_table => "billtrack_member#{ self.table_environment }.bill_issues"  
      
  has_many :politician_issues, :conditions => 'ISNULL(type)'
  has_many :politician_issue_details
  has_and_belongs_to_many :politicians, :select => 'politicians.*',
                          :join_table => "billtrack_member#{ self.table_environment }.politician_issues",
                          :conditions => "ISNULL( politician_issues.type )" 
  
  named_scope :approved, :conditions => {:status => 'approved'}
  named_scope :unapproved, :conditions => "status != 'approved'"
  
  # VALIDATIONS ================
  validates_presence_of   :name
  validates_uniqueness_of :name
  
  # HOOKS ======================
  before_create :status # creates default value
  
  before_validation :fix_name
  def fix_name
    self.name = name.downcase.strip unless name.blank?
  end  
  
  after_save :reset_usage_stats
  def reset_usage_stats
    # each sets class level instance variable
    self.class.highest_usage_count( {:reload => true} )
    self.class.lowest_usage_count( {:reload => true} )
  end  
  
  
  # OTHER METHODS ===========
  # status, state machine
  def status
    (self[:status] ||= self.class.statuses.first.to_s).to_sym
  end  
  
  def status=( s )
    self[:status] = s.to_s
  end  
  
  def self.statuses
    @statuses ||= [:suggested, :approved]
  end  
  
  def status_index
    self.class.statuses.index( status )
  end  
  
  def advance_status
    next_index = status_index + 1
    self.status = self.class.statuses[next_index] unless next_index >= self.class.statuses.size
  end
  
  def advance_status!
    advance_status
    save
    status
  end  
  
  # tag sizing in clouds
  def tag_size(min=0.85, max=1.5)
    tag_span = max - min
    scaled_count * tag_span + min
  end  
  
  # scales the usage count to a fraction under 1 
  def scaled_count
    ( usage_count - self.class.lowest_usage_count ).to_f / self.class.count_span
  end  
  
  def self.count_span
    span = ( highest_usage_count.to_f - lowest_usage_count.to_f )
    span > 0 ? span.to_f : 1.0
  end  
  
  
  def self.highest_usage_count(opts={})
    if opts[:reload] == true || @highest_usage_count.nil?
      @highest_usage_count = maximum(:usage_count, :conditions => {:status => 'approved'}) || 0
      @highest_usage_count = 0 ? @highest_usage_count : 1
    end
    @highest_usage_count
  end
  
  def self.lowest_usage_count(opts={})
    if opts[:reload] == true || @lowest_usage_count.nil?
      @lowest_usage_count = minimum(:usage_count, :conditions => {:status => 'approved'}) || 0
      @lowest_usage_count > 0 ? @lowest_usage_count : 1
    end
    @lowest_usage_count
  end  
  
  # creating from delimited string
  def self.from_string( str )
    set = []
    str.split(',').each do |i|
      set << find_or_create_by(:name => i.strip)
    end
    set  
  end 
  
  # mergers
  def self.merge(parent, child)
    parent.merge_into_self(child)
  end   
  
  def merge_into_other( other )
    other.merge_into_self( self )
  end
  
  def merge_into_self( other )
    other.reassign_bill_issues( self ) # reassign bill_issues
    other.reassign_politician_issues( self ) # reassign politician_issues
    other.destroy # delete other
  end
  
  def reassign_bill_issues( parent )
    bill_issues.each do |bi|
      BillIssue.find_or_create_by(
        :bill_id => bi.bill_id,
        :issue_id => parent.id
      ) # this should create all the related politician_issues
      bi.destroy
    end  
  end  
  
  def reassign_politician_issues( parent )
    # reassign_bill_issues should create all the new politician_issues
    # so we just need to destroy existing records
    politician_issue_details.each do |pid|
      pid.parent.destroy if pid.parent
      pid.destroy
    end
  end  
  
end
