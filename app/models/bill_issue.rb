class BillIssue < ActiveRecord::Base
  # ATTRIBUTES ======================
  # t.integer :bill_id
  # t.integer :issue_id
  attr_accessor :issue_name
  attr_accessor :user_permissions
  attr_accessor :suggested_by
  attr_accessible :bill_id, :issue_id, :issue_name
  
  # RELATIONSHIPS ===================
  belongs_to :bill # in database billtrack_data
  belongs_to :issue, :counter_cache => :usage_count
  
  # HOOKS =============================
  def before_create 
    find_or_create_issue
    generate_politician_issues if :permissioned_and_approved?
  end
    
  def find_or_create_issue
    if issue_name
      self.issue = Issue.find_or_create_by( :name => issue_name )
      self.issue.suggested_by = suggested_by
      self.issue.advance_status if has_permissions?
      self.issue.save
      self.issue_id = issue.id
    end  
    issue
  end
  
  # only do this on save if not already being done inside before_create (which applies order contraints)
  before_save :generate_politician_issues, :if => :permissioned_approved_and_existing?
  
  def generate_politician_issues
    # bill.sponsors + bill.cosponsors not working even after bill is reloaded
    sponsors = BillSponsor.all(:conditions => {:bill_id => bill.id } )
    sponsors.each do |s|
      PoliticianIssueDetail.add(
        :issue_id => issue_id, 
        :politician_id => s.politician_id, 
        :session => bill.congressional_session,
        :politician_role => s.class.to_s
      ).save
    end 
  end 
  
  def permissioned_and_approved?
    has_permissions? && issue && issue.status == :approved
  end 
  
  def permissioned_approved_and_existing?
    has_permissions? && !new_record? && issue && issue.status == :approved
  end    
    
  # INSTANCE METHODS ===================
  
  # this method and the user_permissions accessor should probably be generalize and included 
  # in any suggestable model
  def has_permissions? 
    user_permissions && ( user_permissions.include?( :issues ) || user_permissions.include?( :admin ) )
  end   
  
  def permissions_data=( user )
    self.user_permissions = user.roles
    self.suggested_by = user.id
  end  
end
