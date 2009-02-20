require 'rubygems'

if File.directory?(gems_dir = File.join(Dir.pwd, 'gems')) 
  $BUNDLE = true
  Gem.clear_paths
  Gem.path.unshift(gems_dir)
end

require 'merb-core' 

Merb::Config.setup(:merb_root   => File.expand_path(File.dirname(__FILE__)), 
                   :environment => ENV['RACK_ENV']) 
Merb.environment = Merb::Config[:environment] 
Merb.root = Merb::Config[:merb_root] 
Merb::BootLoader.run 

run Merb::Rack::Application.new