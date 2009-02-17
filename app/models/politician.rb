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
  # district and districts relationships are in Representative and Senator models (STI)
  belongs_to :party
  def party_through_abbreviation(abbrev)
    Merb::Cache[:default].fetch("party_#{abbrev}") do
      Party.find_by_abbreviation(abbrev)
    end
  end  
  has_many :id_lookups,   :as => :parent
  has_many :name_lookups, :as => :parent
  
  # VALIDATIONS 
  
  # INSTANCE METHODS 
  def name
    str = self[:type]
    str << " " + self.first_name
    str << " " + self.last_name
  end  
  
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
  
  def names
    forward_names + backwards_names
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
        :eventful_id, :congresspedia_url, :twitter_id, :youtube_url ].each do |key|
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
    lookup = IdLookup.first(:conditions => {:parent_type => 'Politician', :id_type => 'bioguide_id', :additional_id => sunlight.bioguide_id})
    politician = lookup.parent if lookup
    politician = initialize_from_sunlight( sunlight ) unless politician
    politician.populate_from_sunlight( sunlight )
  end
  
  def populate_from_sunlight( sunlight )
    self.class.sunlight_map.each do |sunlight_key, local_key|
      self.send( "#{local_key}=", sunlight.send( sunlight_key ) )
    end
    self.add_lookups( sunlight )  
    self.district = District.find_or_create(sunlight.state, sunlight.district) if self[:type] == "Representative"
    self.party = Party.find_or_create_by_abbreviation(sunlight.party)
    self
  end 
  
  def add_lookups( sunlight )
    [:bioguide_id, :votesmart_id, :fec_id, :govtrack_id, :govtrack_id, :crp_id].each do |key|
      pol_id = sunlight.send( key )
      IdLookup.find_or_create_by(:parent_id => self.id, :parent_type => 'Politician', :additional_id => pol_id, :id_type => key.to_s ) unless pol_id.blank?
    end
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
  
  def self.update_govtrack_ids
    set = find_by_sql( "
      select * FROM
      	politicians
      	WHERE id NOT IN (
      		SELECT politicians.id as id_set  
      			FROM id_lookups , politicians
      			where id_lookups.parent_id = politicians.id
      			and parent_type = 'Politician'
      			and id_type = 'govtrack_id'
      			group by politicians.id
      	)
      ")
    set.each do |p|
      xml = govtracker.search(:bioguideid => p.bioguide_id)
      p.create_lookup(:govtrack_id => xml.first['id'])
    end  
  end  
  
  def self.govtracker
    @govtracker ||= GovtrackerFile.new(:file => "people.xml", :tag => :person )
  end  
  
  def self.extract_ids
    if columns.collect(&:name).include?( 'bioguide_id' )
      all.each do |pol|
        [:bioguide_id, :votesmart_id, :fec_id, :govtrack_id, :crp_id].each do |id_method|
          pol_id = pol.send(id_method)
          IdLookup.find_or_create_by(:parent_id => pol.id, :parent_type => 'Politician', :additional_id => pol_id, :id_type => id_method.to_s ) unless pol_id.blank?
        end  
      end
    end  
  end 
  
  def self.extract_names
    all.each do |pol|
      pol.names.each do |n|
        NameLookup.find_or_create_by(
          :parent_id => pol.id,
          :parent_type => 'Politician',
          :name => n
        )
      end  
    end  
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
  
  def create_lookup( hash ) 
    id_type = hash.keys.first
    value = hash.values.first
    looker = IdLookup.find_or_create_by({ 
      :parent_type => 'Politician', 
      :additional_id => value.to_s, 
      :id_type => id_type.to_s
    }) 
  end  
  
end
