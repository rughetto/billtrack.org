class Politician < ActiveRecord::Base
  # type -  Senator or Representative, STI ...
  
  # BIO DATA
  # first_name - firstname in Sunlight model
  # middlename  - middlename in Sunlight model
  # lastname  - lastname in Sunlight model
  # name_suffix 
  # nickname  
  # party_id (D, I, or R)
  # state
  # district # only for reps
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
  
end
