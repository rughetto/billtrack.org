class CommitteeBill < ApiData
  belongs_to :committee
  belongs_to :bill
end
