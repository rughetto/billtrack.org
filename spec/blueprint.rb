# Politician Issue
Sham.pi_issue_id(:unique => false)      { rand(9) + 20 }
Sham.pi_politician_id(:unique => false) { rand(10) + 10 }
Sham.pi_session(:unique => false)       { rand(5) + 111 }
Sham.pi_issue_count(:unique => false)   { rand(12) + 1 }
Sham.pi_politician_role(:unique => false){ ['Cosponsor', 'Sponsor'][rand(2)]}

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
