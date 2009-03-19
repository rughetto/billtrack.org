class Politician < ApiData
  # ATTRIBUTES ------------------------------
  # type -  Senator or Representative, STI ...
  
  # BIO DATA
  # first_name - firstname in Sunlight model
  # middle_name  - middlename in Sunlight model
  # last_name  - lastname in Sunlight model
  # name_suffix 
  # nickname  
  # party_id (D, I, or R)
  # state
  # district_number # only for reps
  # district_id # only for reps
  # seat  # only for senators
  # gender
  # active - in_office in the Sunlight model
  
  # CONTACT INFO
  # phone  - Congressional office phone number
  # website  - URL of Congressional website
  # webform  - URL of web contact form
  # email  - Legislator's email address (if known)
  
  # SOCIAL MEDIA ...
  # eventful_id Performer ID on eventful.com
  # congresspedia_url URL of Legislator's entry on Congresspedia
  # twitter_id  Congressperson's official Twitter account
  # youtube_url Congressperson's official Youtube account
  
  # RELATIONSHIPS ---------------------------------------
  # district and districts relationships are in Representative and Senator models (STI)
  belongs_to :party_uncached, :class_name => "Party"
  def party
    @party ||= Party.find_by_id(party_id)
  end  
  def party=( p )
    raise ArgumentError, "expected Party object" if p.class != Party
    self.party_id = p.id
  end  
  
  has_many :id_lookups,   :as => :parent
  has_many :name_lookups, :as => :parent
  
  def state
    @state ||= State.find_by(:code => self[:state] )
  end  
  
  has_many :bill_sponsors
  has_many :sponsored_bills, :through => :bill_sponsors,  :source => :bill, :conditions => "ISNULL(bill_sponsors.type)"
  has_many :cosponsored_bills, :through => :bill_sponsors,  :source => :bill, :conditions => "NOT ISNULL(bill_sponsors.type)"
  
  has_many :politician_issues
  has_and_belongs_to_many :issues, 
                          :join_table => "billtrack_member#{ self.table_environment }.politician_issues",
                          :conditions => 'issues.status = "approved"' 
  
  # VALIDATIONS 
  
  # INSTANCE METHODS 
  def name
    str = self[:type]
    str << " " + self.first_name
    str << " " + self.last_name
  end  
  
  private
    def forward_names
      name_set = ["#{first_name} #{last_name}"]
      if middle_name.blank?
        name_set << "#{nickname} #{last_name}" unless nickname.blank?
      else  
        name_set << "#{first_name} #{middle_name} #{last_name}"
        name_set << "#{nickname} #{middle_name} #{last_name}" unless nickname.blank?
      end
      unless name_suffix.blank?
        name_set.dup.each do |name|
          name_set << "#{name} #{name_suffix}"
        end  
      end 
      name_set | name_set
    end  
  
    def backwards_names
      name_set = ["#{last_name}, #{first_name}"]
      if middle_name.blank?
        name_set << "#{last_name}, #{nickname}" unless nickname.blank?
      else  
        name_set << "#{last_name}, #{first_name} #{middle_name}"
        name_set << "#{last_name}, #{nickname} #{middle_name}" unless nickname.blank?
      end
      unless name_suffix.blank?
        name_set.dup.each do |name|
          name_set << "#{name} #{name_suffix}"
        end  
      end 
      name_set | name_set
    end
  public  
  
  def names
    forward_names + backwards_names
  end
  
  def constituency
    str = "#{party.name} - #{self[:state]}"
    str << ", #{seat} " if self.class == Senator  && seat != '0' 
    str << ", District #{district.number}" if self.class != Senator
    str
  end  
  
  # I want to move the photos into the class using paperclip --------
  def thumbnail_path
    "govtrack_us/photos/#{govtrack_id}-100px.jpeg"
  end  
  
  def small_photo_path
    "govtrack_us/photos/#{govtrack_id}-200px.jpeg"
  end  
  
  def photo_path
    file_location = "govtrack_us/photos/#{govtrack_id}.jpeg"
  end  
  
  def govtrack_id
    @looker ||= id_lookups.select{|lookup| lookup.id_type == 'govtrack_id'}.first
    @looker.additional_id if @looker
  end 
  
  def self.lookup( hash )
    id_type = hash.keys.first
    value = hash.values.first
    looker = IdLookup.first(:conditions => { 
      :parent_type => 'Politician', 
      :additional_id => value.to_s, 
      :id_type => id_type.to_s
    })
    looker ? looker.parent : nil
  end 
  
  def self.name_lookup( n )
    looker = NameLookup.first(:conditions => {:name => n, :parent_type => 'Politician' })
    looker ? looker.parent : nil
  end  
  
end
