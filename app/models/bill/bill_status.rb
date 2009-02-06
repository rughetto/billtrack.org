class BillStatus < ActiveRecord::Base
  # ATTRIBUTES ======================
    # t.integer :bill_id
    # t.date    :date
    # t.string  :chamber # where in bill statuses
    # t.string  :result
    # t.string  :method
    # t.string  :details
    # t.string  :status_type # vote, introduced, etc. name of tag inside bill<status tag
  
  # RELATIONSHIPS ===================
  belongs_to :bill
  
  # SAMPLE DATA FROM AMENDMENT
  # <status date="1231266540" datetime="2009-01-06T14:29:00-05:00">fail</status>
  # SAMPLE DATA FROM BILL
  # <status>
  #   <vote date="1233180660" datetime="2009-01-28T18:11:00-05:00" where="h" result="pass" how="roll" roll="46"/>
  #   <introduced date="1231218000" datetime="2009-01-06"/>
  # </status>
  
  # IMPORTING =======================  
  def self.import_set(xml, b)
    raise ArgumentError, 'Bill must be saved before adding a status' if b.new_record?
    bill_id = b.id
    set = []
    (xml/:status).each do | status_xml |
      if b.class == Bill
        status_xml.children.each do |child|
          unless child.blank?
            status_type = child.name
            date =    child["date"]
            date =    Time.at(date.to_i) if date
            chamber = child["where"]
            result =  child["result"]
            method =  child["how"]
            details = child["roll"]
            attrs = {
              :bill_id => bill_id,
              :status_type => status_type,
              :date => date,
              :chamber => chamber,
              :result => result,
              :method => method,
              :details => details
            }
            set << find_or_create_by( attrs )
          end  
        end  
      else # Amendment
        date = status_xml["date"]
        date = Time.at(date.to_i) if date
        result = status_xml.inner_html
        attrs = {
          :bill_id => bill_id,
          :date => date,
          :result => result
        }
        set << find_or_create_by( attrs )
      end
    end
    set 
  end 

end
