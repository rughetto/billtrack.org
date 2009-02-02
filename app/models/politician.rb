class Politician < ActiveRecord::Base
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
  
  # IDS - not sure how many of these I will want/need
  # bioguide_id  - Legislator ID assigned by Congressional Biographical Directory (also used by Washington Post/NY Times)
  # votesmart_id   - Legislator ID assigned by Project Vote Smart
  # fec_id  - Federal Election Commission ID
  # govtrack_id,  - ID assigned by Govtrack.us
  # crp_id  ID provided by Center for Responsive Politics
  
  # RELATIONSHIPS ---------------------------------------
  belongs_to :party
  def party_through_abbreviation(abbrev)
    Merb::Cache[:default].fetch("party_#{abbrev}") do
      Party.find_by_abbreviation(abbrev)
    end
  end  
  # district and districts relationships are in Representative and Senator models (STI)
  
  # VALIDATIONS 
  validates_presence_of :bioguide_id
  validates_uniqueness_of :bioguide_id
  
  # INSTANCE METHODS 
  def name
    str = self[:type]
    str << " " + self.first_name
    str << " " + self.last_name
  end  
  
  
  # IMPORTING DATA FROM SUNLIGHT
  private
    def self.sunlight_map
      {
        :firstname => :first_name,
        :middlename => :middle_name,
        :lastname => :last_name,
        :in_office => :active
      }.merge( direct_sunlight_map )
    end
  
    def self.direct_sunlight_map
      hash = {}
      [ :name_suffix, :nickname, :state, :gender, :phone, :website, :webform, :email, 
        :eventful_id, :congresspedia_url, :twitter_id, :youtube_url,  
        :bioguide_id, :votesmart_id, :fec_id, :govtrack_id, :govtrack_id, :crp_id ].each do |key|
        hash[key] = key
      end
      hash    
    end    
  public  
      
  
  def self.new_from_sunlight( sunlight )
    initialize_from_sunlight( sunlight ).populate_from_sunlight( sunlight )
  end 
  
  def self.initialize_from_sunlight( sunlight )
    if sunlight.title.match(/Rep/i)
      politician = Representative.new(:district_number => sunlight.district )
    else
      politician = Senator.new(:seat => sunlight.district )
    end
    politician
  end   
  
  def self.from_sunlight( sunlight )
    politician = first(:conditions => {:bioguide_id => sunlight.bioguide_id})
    politician = initialize_from_sunlight( sunlight ) unless politician
    politician.populate_from_sunlight( sunlight )
  end
  
  def populate_from_sunlight( sunlight )
    self.class.sunlight_map.each do |sunlight_key, local_key|
      self.send( "#{local_key}=", sunlight.send( sunlight_key ) )
    end
    self.district = District.find_or_create(sunlight.state, sunlight.district) if self[:type] == "Representative"
    self.party = Party.find_or_create_by_abbreviation(sunlight.party)
    self
  end 
  
  def self.import_from_sunlight
    all_active_from_sunlight.each do |sunlight|
      from_sunlight(sunlight).save
    end  
    all
  end 
  
  def self.all_active_from_sunlight
    Sunlight::Legislator.all_where(:in_office => 1)
  end     
  
end
