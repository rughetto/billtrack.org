# this whole model is a database shortcut to statistics about the bill_issues
# it should be able to be deleted and recalculated at will. It should also be
# dynamic and tied into BillIssue creation and deletion.

class PoliticianIssue < ActiveRecord::Base
  # ATTIRBUTES ===========================
    # t.integer :politician_id
    # t.integer :issue_id
    # t.string  :type
    # t.integer :issue_count, :default => 0
    # t.integer :score,       :default => 0
    # t.string  :politician_role
    # t.integer :session
  attr_accessor :child_score  
  
  # RELATIONSHIPS ========================
  belongs_to :politician 
  belongs_to :issue
  has_many   :details, :class_name => 'PoliticianIssueDetail', 
    :primary_key => :politician_id, :foreign_key => :politician_id
  has_many   :siblings, :class_name => 'PoliticianIssue',
    :primary_key => :politician_id, :foreign_key => :politician_id,
    :conditions => 'ISNULL(type) AND issue_id != #{issue_id}'
  
  # VALIDATIONS ==========================
  validates_presence_of :politician_id, :issue_id, :score, :issue_count
  validate :validate_numbers_greater_than_zero
  
  def validate_numbers_greater_than_zero
    errors.add(:issue_count, 'must be greater than 0')  unless issue_count > 0
    errors.add(:score, 'must be greater than 0')        unless score > 0
  end  
  
  
  # HOOKS ================================
  before_validation :calculate_score
  
  # called by PoliticianIssueSpec in add method
  def recalc_siblings
    siblings.each do |s|
      s.score_will_change!
      s.save # recalculates score
    end
    siblings = nil # clears existing set
    siblings # returns recalculated set
  end  
  
  # ISSUE SCORING/RATING =================
  def calculate_score # on a 1 to 10 basis
    calculate_issue_count
    score = ( ( issue_count.to_f - min_issue_count_for_politician.to_f ) / score_denomenator ) * 10
    self.score = score < 1 ? 1.0 : score
  end
  
  # tag sizing in clouds
  def tag_size(min=0.85, max=1.5)
    tag_span = max - min
    scaled_count * tag_span + min
  end
  
  def scaled_count 
    ( score - 1 ).to_f / 9
  end
  
  def score_denomenator
    denomenator = ( max_issue_count_for_politician.to_f - min_issue_count_for_politician.to_f )
    denomenator == 0 ? 1 : denomenator
  end  
  
  def calculate_issue_count
    self.issue_count = PoliticianIssueDetail.sum( 
      :score, 
      :conditions => {
        :politician_id => politician_id, 
        :issue_id => issue_id 
      }
    ).round + ( child_score || 0 ).round
  end  
  
  def issue_count
    self[:issue_count] ||= 0
  end  
  
  def max_issue_count_for_politician
    [ self.class.maximum( :issue_count, :conditions => {:politician_id => self.politician_id, :type => nil} ) || 1, 
      issue_count ].max
  end 
  
  def min_issue_count_for_politician
    [ self.class.minimum( :issue_count, :conditions => {:politician_id => self.politician_id, :type => nil} ) || 1, 
      issue_count ].min
  end 
  
end
