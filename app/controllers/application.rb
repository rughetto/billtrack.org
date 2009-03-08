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
  
  # permissions system
    def ensure_permissioned
      unless (  session.user.roles.include?( controller_permission_symbol ) ||
                session.user.roles.include?( :admin ) ) 
        raise Forbidden
      end  
    end  
  
    private
      def controller_permission_symbol
        @controller_permission_symbol ||= controller_name.match(/(\w*)$/).to_s.to_sym
      end
    public
  # --- end permissions system  
  
end