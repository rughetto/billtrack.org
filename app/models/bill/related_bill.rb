class RelatedBill < ActiveRecord::Base
  # ATTRIBUTES =======================
    # t.integer :bill_id
    # t.integer :related_bill_id
    # t.string  :relationship
    # t.string  :related_bill_data
    
  belongs_to :bill
  belongs_to :related_bill, :class_name => 'Bill'  
  
  def self.import_set( xml, b )
    set = []
    (xml/:bill).each do |sub_xml|
      #<bill relation="rule" session="111" type="hr" number="88" />
      relationship = sub_xml['relation'].to_s
      related_bill_data = {
        :congressional_session => sub_xml['session'].to_s,
        :chamber => sub_xml['type'].to_s,
        :number => sub_xml['number'].to_s
      }
      related_bill = find_related( related_bill_data )
      attr_hash = { :relationship => relationship, :related_bill_data => related_bill_data.inspect }
      if related_bill
        attr_hash.merge!({ :related_bill_id => related_bill.id })
      end
      if b.id
        attr_hash.merge!({ :bill_id => b.id })
      end  
      set << find_or_create_by( attr_hash )  
    end
    set
  end  
  
  def self.find_related( attr_hash )  
    attr_hash = eval(attr_hash) if attr_hash.class == String
    Bill.find_by( attr_hash )
  end  
    
end
