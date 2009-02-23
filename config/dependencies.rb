merb_gems_version = "1.0.8.1"
ar_gems_version   = "2.2.2"

dependency "merb-action-args",          merb_gems_version
dependency "merb-assets",               merb_gems_version  
dependency "merb-cache",                merb_gems_version   
dependency "merb-helpers",              merb_gems_version 
dependency "merb-mailer",               merb_gems_version  
dependency "merb-slices",               merb_gems_version  
dependency "merb-auth",                 merb_gems_version
dependency "merb-auth-core",            merb_gems_version
dependency "merb-auth-more",            merb_gems_version
dependency "merb-auth-slice-password",  merb_gems_version
dependency "merb-param-protection",     merb_gems_version
dependency "merb-exceptions",           merb_gems_version
dependency "merb-gen",                  merb_gems_version

dependency "activesupport",             ar_gems_version
dependency "activerecord",              ar_gems_version
dependency "merb_activerecord"

dependency "RedCloth"
dependency "rughetto-merb_paperclip",             :require_as => "merb_paperclip"
dependency "rughetto-rear_views",                 :require_as => "rear_views"
dependency "rughetto-sunlight",                   :require_as => "sunlight"
dependency "collectiveidea-awesome_nested_set",   :require_as => "awesome_nested_set"
  # ActiveRecord include also added to init.rb to get nested sets working
dependency "nokogiri"
dependency 'rughetto-merb_paginate',              :require_as => 'merb_paginate'

# testing factories!
dependency "notahat-machinist",         :require_as => "machinist"
dependency "faker"