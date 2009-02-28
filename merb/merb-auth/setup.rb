Merb::Plugins.config[:"merb-auth"][:login_param] = :username 
begin
  Merb::Authentication.user_class = Member 
  
  # Mixin the salted user mixin
  require 'merb-auth-more/mixins/salted_user'
  Merb::Authentication.user_class.class_eval{ include Merb::Authentication::Mixins::SaltedUser }
    
  # Setup the session serialization
  class Merb::Authentication

    def fetch_user(session_user_id)
      Merb::Authentication.user_class.find(session_user_id)
    end

    def store_user(user)
      Merb.logger.debug("user = #{user.inspect}")
      user.nil? ? user : user.id
    end
  end
rescue
  Merb.logger.error <<-TEXT
  
    You need to setup some kind of user class with merb-auth.  
    Merb::Authentication.user_class = User
    
    If you want to fully customize your authentication you should use merb-core directly.  
    
    See merb/merb-auth/setup.rb and strategies.rb to customize your setup

    TEXT
end

