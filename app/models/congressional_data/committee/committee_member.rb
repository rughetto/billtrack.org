class CommitteeMember < ApiData
  belongs_to :committee
  belongs_to :politician

end
