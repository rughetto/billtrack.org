# NEED TO LOCK DOWN attr_accessibility for roles

class Member < ActiveRecord::Base
  # INCLUSIONS & EXTENSIONS ======
  include Merb::Authentication::Mixins::ActivatedUser
  include Merb::Authentication::Mixins::SenileUser
  has_zipcode_accessor # from /lib/zipcoder
  
  # ATTRIBUTES ===================
  # t.string :username
  # t.string :salt
  # t.string :crypted_password
  # t.string :email
  # 
  # # slice auth vars
  # t.string    :password_reset_code        # merb-auth-slice-password-reset 
  # t.datetime  :activated_at               # MerbAuthSliceActivation
  # t.string    :activation_code            # MerbAuthSliceActivation
  # t.datetime  :remember_token_expires_at  # merb-auth-remember-me
  # t.string    :remember_token             # merb-auth-remember-me
  # 
  # t.string :roles
  # 
  # t.string  :first_name
  # t.string  :last_name
  # t.text    :visibility # hash {:first_name => true, :last_name => false, :zipcode => true}
  # 
  # t.text    :address
  # t.string  :city
  # t.string  :zip_main
  # t.string  :zip_plus_four
  # t.string  :state_id
  # 
  # t.integer :district_id
  # t.integer :party_id
  # 
  # t.timestamps
  
  # VALIDATIONS ==================
  validates_presence_of     :username, :email
  validates_uniqueness_of   :username, :if => :validate_username?
  validates_uniqueness_of   :email, :if => :validate_email?
  validates_format_of :username, :with => /^\w+$/i,
    :message => "must be a combination of English letters and numbers with no spaces",
    :if => :validate_username?
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
    :message => "is not a valid format",
    :if => :validate_email?
  validates_length_of :username, :minimum => 3, :message => 'must be 3 or more characters', :if => :validate_username? 
  validates_length_of :password, :minimum => 6, :message => 'password should be at least 6 characters', :if => :password_required?
  
  def validate_username?
    username_changed?
  end  
  
  def validate_email?
    email_changed?
  end  
  
  def password_required?
    new_record? || !password.nil?
  end  
  
  # RELATIONSHIPS ================
  # these are all records loaded into memory ---------------
  def state
    @state ||= State.find_by_id(state_id)
  end   
  def state=( s )
    if s.class == String || s.class == Fixnum
      self.state_id = s.to_s
    elsif s.class = State
      self.state_id = s.id
    else
      raise ArgumentError, "should be State object or a Fixnum identifying the State id"
    end    
    state 
  end  
  
  def party
    @party ||= Party.find_by_id(party_id)
  end  
  def party=( p )
    raise ArgumentError, "expected Party object" if p.class != Party
    self.party_id = p.id
  end  
  
  def district
    @district ||= District.find_by_id( district_id )
  end
  def district=( d )  
    raise ArgumentError, 'expected District object' if d.class != District
    self.district_id = d.id
  end  
  
  has_many :district_maps, :primary_key => :zip_main, :foreign_key => :zip_main
  
  # PERMISSIONS ====================
  def roles
    if @roles.blank?
      if self[:roles] == nil
        @roles = []
      else  
        @roles ||= self[:roles].split(self.class.role_seperator).collect(&:to_sym)
        @roles = check_roles( @roles )
      end  
    end
    @roles  
  end
  
  def roles=(r)
    if r.class == String
      self[:roles] = r
      clear_roles_ivar
    elsif r.class == Array
      self[:roles] = r.join(self.class.role_seperator)
      clear_roles_ivar
    elsif r.nil?
      self[:roles] = nil
      clear_roles_ivar
    else  
      raise ArgumentError, 'argument must be either a String (of comma seperated values), or an Array of strings'
    end  
    roles
  end 
  
  private
    def clear_roles_ivar
      @roles = nil
    end  
  public  
  
  def self.role_seperator
    ', '
  end   
  
  def self.acceptable_roles
    [:admin, :issues]
  end   
  
  def check_roles( r )
    # intersection of r and self.class.acceptable_roles
    r
  end  
  
  def has_permissions?( controller )
    roles.include?(:admin) || roles.include?(controller.to_s.downcase.to_sym)
  end   
  
  # DISTRICT CONNECTION --------------
  def find_district
    
  end  
  
  
end
