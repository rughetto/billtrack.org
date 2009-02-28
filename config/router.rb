Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")
  slice(:merb_auth_slice_activation, :name_prefix => nil, :path_prefix => "")
  slice(:merb_auth_slice_password_reset, :name_prefix => nil, :path_prefix => '')
  
  resources :members
  resources :politicians
  resources :bills
  resources :issues

  # authenticate do
    # ...
  # end

  # this should change to a dashboard controller 
  #   with index being the unlogged in home page
  #   and show being the user specific home page after login
  match('/').to(:controller => 'csser', :action =>'index')
end