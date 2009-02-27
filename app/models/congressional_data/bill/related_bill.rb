class RelatedBill < ApiData
  # ATTRIBUTES =======================
    # t.integer :bill_id
    # t.integer :related_bill_id
    # t.string  :relationship
    # t.string  :related_bill_data
    
  belongs_to :bill
  belongs_to :related_bill, :class_name => 'Bill'  
    
end
