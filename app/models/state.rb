class State < ActiveRecord::Base
  
  def self.create_all
    {
      'ALABAMA' => 'AL',
      'ALASKA' => 'AK',
      'ARIZONA' => 'AZ',
      'ARKANSAS' => 'AR',
      'CALIFORNIA' => 'CA',
      'COLORADO' => 'CO',
      'CONNECTICUT' => 'CT',
      'DELAWARE' => 'DE',
      'DISTRICT OF COLUMBIA' => 'DC',
      'FLORIDA' => 'FL',
      'GEORGIA' => 'GA',
      'HAWAII' => 'HI',
      'IDAHO' => 'ID' ,
      'ILLINOIS' => 'IL',
      'INDIANA' => 'IN',
      'IOWA' => 'IA',
      'KANSAS' => 'KS',
      'KENTUCKY' => 'KY',
      'LOUISIANA'  => 'LA',
      'MAINE' => 'ME',
      'MARYLAND' => 'MD',
      'MASSACHUSETTS' => 'MA',
      'MICHIGAN' => 'MI',
      'MINNESOTA' => 'MN',
      'MISSISSIPPI' => 'MS',
      'MISSOURI' => 'MO',
      'MONTANA' =>  'MT',
      'NEBRASKA' => 'NE',
      'NEVADA' => 'NV',
      'NEW HAMPSHIRE' => 'NH',
      'NEW JERSEY' => 'NJ',
      'NEW MEXICO' => 'NM',
      'NEW YORK' => 'NY',
      'NORTH CAROLINA' => 'NC',
      'NORTH DAKOTA' => 'ND',
      'OHIO' => 'OH',
      'OKLAHOMA' => 'OK',
      'OREGON' => 'OR',
      'PENNSYLVANIA' => 'PA',
      'RHODE ISLAND' => 'RI',
      'SOUTH CAROLINA' => 'SC',
      'SOUTH DAKOTA' => 'SD',
      'TENNESSEE' => 'TN',
      'TEXAS' => 'TX',
      'UTAH' => 'UT',
      'VERMONT' => 'VT',
      'VIRGINIA' => 'VA',
      'WASHINGTON' => 'WA',
      'WEST VIRGINIA' => 'WV',
      'WISCONSIN' => 'WI',
      'WYOMING' =>  'WY'
    }.each do |state_name, state_code|
      state = State.find_or_create_by(:code => state_code)
      state.name = state_name.titlecase
      state.get_location
      state.zoom_level = '1'
      state.save
    end  
  end  
  
  def get_location
    struct = Geocoding::get(self.name).first
    if struct
      self.latitude = struct.latitude
      self.longitude = struct.longitude
    end  
  end  

  
end
