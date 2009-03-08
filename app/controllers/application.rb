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
      raise Forbidden unless has_permissions?
    end  
    
    def has_permissions?
      session.user && 
      ( session.user.roles.include?( controller_permission_symbol ) ||
        session.user.roles.include?( :admin ) )
    end  
  
    private
      def controller_permission_symbol
        @controller_permission_symbol ||= controller_name.match(/(\w*)$/).to_s.to_sym
      end
    public
  # --- end permissions system  
  
end