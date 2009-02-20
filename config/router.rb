Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  resources :members
  #resources :districts
  resources :politicians
  #resources :parties
  resources :bills

  # authenticate do
  #   resources :members
  #   resources :invoices
  #   resources :projects
  #   resources :services
  #   resources :times
  #   resources :users
  #   resources :notes
  #   match('/').to(:controller => 'times', :action =>'index')
  # end

  match('/').to(:controller => 'csser', :action =>'index')
end