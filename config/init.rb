# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm             :activerecord
use_test            :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '799104a7f56904b0c7163665024e4f72cb89e6be'  # required for cookie session store
  c[:session_id_key] = '_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # adding libraries
  require File.join( File.dirname(__FILE__), '..', 'lib', 'poor_mans_memecache')
  require File.join( File.dirname(__FILE__), '..', 'lib', 'zipcoder')
  require File.join( File.dirname(__FILE__), '..', 'lib', 'fixturizer')
  require File.join( File.dirname(__FILE__), '..', 'lib', 'versatile_finders')
  require File.join( File.dirname(__FILE__), '..', 'lib', 'google_mapper')
  ActiveRecord::Base.class_eval do
    include CollectiveIdea::Acts::NestedSet
    extend Fixturizer::ActiveRecord
  end
  
  # Auth-Activation Configuration
  Merb::Slices::config[:merb_auth_slice_activation][:from_email] = 'info@billtrack.org'
  Merb::Slices::config[:merb_auth_slice_activation][:activation_host] = 'billtrack.org'
  Merb::Slices::config[:merb_auth_slice_activation][:welcome_subject] = 'Wellcome to BillTrack.org'
  Merb::Slices::config[:merb_auth_slice_activation][:activation_subject] = 'Your BillTrack.org account is now active!'
end
 
Merb::BootLoader.after_app_loads do
  Time::DATE_FORMATS[:us_date] = "%D"
  
  Merb::Cache.setup do
    unless exists?(:default)
      register(:default, Merb::Cache::FileStore, :dir => Merb.root / :tmp / :cache) 
    end   
  end
end
