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

  # status, state machine
  def status
    (self[:status] ||= self.class.statuses.first).to_sym
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
  
    
  
end
