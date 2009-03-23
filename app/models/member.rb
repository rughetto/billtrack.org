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
  
  # HOOKS ========================
  before_save :find_district, :if => :district_changing?
  
  def district_changing?
    new_record? or district_id_changed? or zip_main_changed? or zip_plus_four_changed? or address_changed? or city_changed? || state_id_changed? 
  end  
  
  def find_district
    # have to use get_district_map instead of district_maps since it won't find the relationship 
    # for unsaved record, even though relationship is not dependent on the record id, 
    # which is nil for a new record
    if district_changing?
      if get_district_maps.size == 1
        district_id_will_change!
        self.district_id = get_district_maps.first.district_id 
      elsif get_district_maps.size > 1
        unless address.blank? # try to find the correct district from the address
          address_str = address.to_s
          address_str << " #{city}, " unless city.blank?
          address_str << " #{state.code} " if state 
          address_str << " #{zipcode} " if zipcode
          sunlight_district = Sunlight::District.get( :address => address_str )
          if sunlight_district
            d = District.find_by( :state => sunlight_district.state, :number => sunlight_district.number ) 
            district_id_will_change! if d
            self.district_id = d.id if d
          end  
        end  
      end
    end  
    district    
  end 
  
  # RELATIONSHIPS ================
  # these related records are all records loaded into memory 
  # hence the method call rather than the relationship definition
  # ---------------
  def state
    @state ||= State.find_by_id(state_id)
  end   
  def state=( s )
    if s.class == String || s.class == Fixnum
      self.state_id = s.to_s
    elsif s.class == State
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
  def get_district_maps
    @dms ||= DistrictMap.all(:conditions => {:zip_main => zip_main})
  end  
  
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
    r & self.class.acceptable_roles # intersection of two arrays, ie acceptable values
  end  
  
  def has_permissions?( controller='' ) # default usage with no argument just checks for admin
    roles.include?(:admin) || roles.include?(controller.to_s.downcase.to_sym)
  end   
  
  
end
