Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  default_routes
  
  match('/').to(:controller => 'csser', :action =>'index')
end