# Politician Issue
Sham.pi_issue_id(:unique => false)      { rand(9) + 20 }
Sham.pi_politician_id(:unique => false) { rand(10) + 10 }
Sham.pi_session(:unique => false)       { rand(5) + 111 }
Sham.pi_issue_count(:unique => false)   { rand(12) + 1 }
Sham.pi_politician_role(:unique => false){ ['Cosponsor', 'Sponsor'][rand(2)] }
# Bill
Sham.bill_chamber(:unique => false){ ['s', 'h', 'hc', 'hr', 'sr'][rand(5)] }
Sham.bill_number { rand(100) }

PoliticianIssueDetail.blueprint do 
  issue_id      { Sham.pi_issue_id }
  politician_id { Sham.pi_politician_id }
  session       { Sham.pi_session }
  issue_count   { Sham.pi_issue_count }
  politician_role {Sham.pi_politician_role }
end  

PoliticianIssue.blueprint do 
  issue_id      { Sham.pi_issue_id }
  politician_id { Sham.pi_politician_id }
  issue_count   { Sham.pi_issue_count }
end

Bill.blueprint do 
  congressional_session { Sham.pi_session }
  chamber { Sham.bill_chamber }
  number { Sham.bill_number }
end

Politician.blueprint do 
  active { 1 }
  first_name { Faker::Name.name  }
  middle_name { Faker::Name.name  }
  last_name { Faker::Name.name  }
end  

Bill.blueprint do
  chamber { Sham.bill_chamber }
  congressional_session { Sham.pi_session }
  number { Sham.bill_number }
end    