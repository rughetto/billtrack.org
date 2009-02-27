class BillSubject < ApiData
  belongs_to :bill
  belongs_to :legislative_issue

end
