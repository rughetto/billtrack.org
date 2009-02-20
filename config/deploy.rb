set :keep_releases, 5

# server user
set :user,            "billtrack"
set :password,        "B1ll***Tr@ck"
set :use_sudo,        false
set :port,            2002
default_run_options[:pty] = true

# application
set :application, "billtrack.org"
set :deploy_to,   "/home/#{user}/#{application}"

# database
set :database,        "#{user}"
set :dbuser,          user
set :dbpass,          password

# repository
set :repository,  "git@ruby_passenger:bill_track.git" 
set :deploy_via,  :remote_cache
set :scm,         :git
set :branch,      "master"
set :scm_verbose, true
set :scm_port,    2002

# IPs
role :app, "#{user}"
role :web, "#{user}"
role :db,  "#{user}", :primary => true

desc "Link in shared things" 
task :after_symlink do
  # symlink log path
  run "ln -nfs #{shared_path}/log #{release_path}/log" 
  # config/database
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
end

desc "Merb AR migration of database" 
deploy.task :migrate, :roles => :app do
  run "cd #{current_path}; bin/rake MERB_ENV=production  db:migrate"
end  


desc "Restart Application"
deploy.task :restart, :roles => :app do
  run "cd #{current_path}; bin/thor merb:gem:redeploy"
  run "touch #{current_path}/tmp/restart.txt"
end

namespace :merb do
  desc "Redeploy Gems"
  task :redeploy_gems do
    run "cd #{current_path}; bin/thor merb:gem:redeploy"
  end  
end  

