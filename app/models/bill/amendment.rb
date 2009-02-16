class Amendment < Bill
  # RELATIONSHIPS ==============================
  belongs_to :bill, :foreign_key => :parent_id
  has_many :statuses, :class_name => "BillStatus"
  has_many :actions, :class_name => "BillAction"
  has_many :bill_sponsors
  has_many :sponsors, :through => :bill_sponsor
  
  # IMPORTS =====================================
  def self.govtracker
    @govtracker ||= GovtrackerFileSet.new(:dir => '111/bills.amdt', :tag => "amendment")
  end
  
  def self.import_data( file_data )
    file_data = (file_data/:amendment).first
    attrs = file_data.attributes
    amdt = find_or_create_by( 
      :congressional_session => attrs["session"].to_s, 
      :chamber => attrs["chamber"].to_s,
      :number => attrs["number"].to_s
    )
    xml_updated_at = attrs["updated"].to_s
    amdt.xml_updated_at = Time.parse(xml_updated_at)
    introduced_at = (file_data/"offered").first['date']
    amdt.introduced_at = Time.at(introduced_at.to_i)
    amdt.short_title = (file_data/"description").inner_html
    amdt.title = (file_data/"purpose").inner_html
    amdt.sequence = (file_data/"amends").first['sequence'].to_s
    parent_data = (file_data/"amends").first
    parent_data = {
      :number => parent_data["number"],
      :chamber => parent_data["type"]
    }
    amdt.parent_name = parent_data.inspect
    amdt.bill = find_bill( parent_data )
    amdt.save
    
    # relationships
    amdt.statuses << status_set =  BillStatus.import_set(file_data, amdt)
    amdt.actions << action_set =   BillAction.import_set(file_data/"actions", amdt)
    amdt.bill_sponsors << sponsor_set = BillSponsor.import_set( file_data, amdt )
    
    amdt.save
    amdt
  end 
  
  def self.find_bill( bill_attrs )
    bill_attrs = eval( bill_attrs ) if bill_attrs.class == String
    find_by( bill_attrs )
  end  
  

end  