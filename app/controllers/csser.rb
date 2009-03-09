class Csser < Application
  def index
    @issues = Issue.all(:conditions => {:status => 'approved'})
    render
  end  
end  