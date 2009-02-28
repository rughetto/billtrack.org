class Member < ActiveRecord::Base
  # INCLUSIONS & EXTENSIONS ======
  include Merb::Authentication::Mixins::ActivatedUser
  include Merb::Authentication::Mixins::AuthenticatedUser
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
  validates_uniqueness_of   :username, :email
  validates_format_of :username, :with => /^\w+$/i,
    :message => "must be a combination of English letters and numbers with no spaces"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
    :message => "is not a valid format"
  validates_length_of :username, :minimum => 3, :message => 'must be 3 or more characters'  
  validates_length_of :password, :minimum => 6, :message => 'password should be at least 6 characters', :if => :password_required?
  
  def password_required?
    new_record? || !password.nil?
  end  
  
  # RELATIONSHIPS ================
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
  
end
