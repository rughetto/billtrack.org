class Application < Merb::Controller
  
  before :try_authentication
  def try_authentication
    @authenticated = (session.authenticated?) 
    unless @authenticated
      begin 
        @authenticated = session.authenticate!(request, params)
      rescue
        @authenticated = false
      end
    end
  end  
  
end