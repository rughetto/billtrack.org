class Csser < Application
  def index
    @issues = Issue.approved
    render
  end  
end  