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

  # HOOKS ======================
  before_create :status
  
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
    ( span < 0 ? span : 1 ).to_f
  end  
  
  
  def self.highest_usage_count(opts={})
    if opts[:reload] || @total_records.nil?
      @higest_usage_count ||= maximum(:usage_count, :conditions => {:status => 'approved'}) || 0
    end
    @higest_usage_count > 0 ? @higest_usage_count : 1
  end
  
  def self.lowest_usage_count(opts={})
    if opts[:reload] || @total_records.nil?
      @lowest_usage_count ||= minimum(:usage_count, :conditions => {:status => 'approved'}) || 0
    end
    @lowest_usage_count > 0 ? @lowest_usage_count : 1
  end  
  
  
end
