Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")
  slice(:merb_auth_slice_activation, :name_prefix => nil, :path_prefix => "")
  slice(:merb_auth_slice_password_reset, :name_prefix => nil, :path_prefix => '')
  
  resources :members
  match('/signup').to(:controller => 'members', :action => 'new').name('signup')
  resources :politicians
  resources :bills
  resources :issues
  resources :bill_issues

  authenticate do
    namespace :admin do 
      resources :issues
    end  
  end

  # this should change to a dashboard controller 
  #   with index being the unlogged in home page
  #   and show being the user specific home page after login
  match('/').to(:controller => 'csser', :action =>'index')
  
  # this checks all uncaught routing and sends it to the info controller, if a template exists
  match(/.+/).defer_to do |request, params|
    template_path = request.env["REQUEST_URI"].split('/')
    template_path.shift # remove first empty string value
    template_path = template_path.join('/') # repackage the string, no ending slash
    template_match = false
    if File.exists?( Merb.root + '/app/views/info/' + template_path + '.html.erb' )
      template_match = true
    else # check to see if it is the index template of a folder 
      if File.exists?( Merb.root + '/app/views/info/' + template_path + '/index.html.erb' )
        template_path += "/index"
        template_match = true
      end  
    end    
    if template_match
      params.merge!(:controller => "info", :action => "show", :template_path => template_path )
    else
      return false
    end    
  end
  
end