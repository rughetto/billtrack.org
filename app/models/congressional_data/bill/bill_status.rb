class BillStatus < ApiData
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
  

end
