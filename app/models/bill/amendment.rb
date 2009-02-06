class Amendment < Bill
  belongs_to :bill, :foreign_key => :parent_id
  
  def self.govtracker
    GovtrackerFileSet.new(:dir => '111/bills.amdt', :tag => "amendment").parsed_file
  end
  
  def self.import_data( file_data )
    attrs = file_data.attributes
    amdt = find_or_create( 
      :congressional_session => attrs["session"].to_s, 
      :chamber => attrs["chamber"].to_s,
      :number => attrs["number"].to_s
    )
    xml_updated_at = attrs["updated"].to_s
    introduced_at = (file_data/"offered").get_attribute("date").to_s
    amdt.xml_updated_at = Time.parse(xml_updated_at)
    amdt.short_title = (file_data/"description").inner_html
    amdt.title = (file_data/"purpose").inner_html
    amdt.introduced_at = Time.at(introduced_at.to_i)
    parent_data = (file_data/"amends").attributes
    amdt.parent_name = parent_data.inspect
    amdt.parent = find_bill( parent_data )
    
    # relationships
    statuses << status_set =  BillStatus.import_data(file_data/"status", self)
    actions << action_set =   BillAction.import_data(file_data/"actions", self)
    
    amdt.save
    
  end 
  

end  