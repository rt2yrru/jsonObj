require 'bundler/capistrano'

set(:application) { "jsonObj" }

set :keep_releases, 3

default_run_options[:pty] = true
set :repository, "git://github.com/richa/jsonObj.git"
set :scm, :git

ssh_options[:forward_agent] = true

set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :user, 'ubuntu'
set :use_sudo, false
set :deploy_to, "/home/ubuntu/apps/jsonObj"

set :location1, "ec2-50-16-156-216.compute-1.amazonaws.com"
set :location2, "ec2-174-129-113-128.compute-1.amazonaws.com"
role :web,      location1, location2
role :app,      location1, location2
role :db,       location1, location2, :primary => true
role :memcache, "jsoncache.6hkbzr.0001.use1.cache.amazonaws.com"

set :rails_env, "production"

namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{ current_path }/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    task t, :roles => :app do ; end
  end

  desc "Deploy with migrations"
   task :long do
     transaction do
       update_code
       web.disable
       symlink
       migrate
     end

     restart
     web.enable
     cleanup
   end

  task :custom_symlink, :roles => :app do
    run "ln -s #{ shared_path }/database.yml #{ current_path }/config/database.yml"
  end
    
  after "deploy:symlink", "deploy:custom_symlink"
  
end
require './config/boot'