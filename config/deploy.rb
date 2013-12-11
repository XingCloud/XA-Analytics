require "rvm/capistrano"
require "capistrano-resque"

set :rvm_ruby_string, "1.9.3"
set :rvm_type, :user
set :rvm_install_type, :head

#before 'deploy:setup', 'rvm:install_rvm'
#before 'deploy:setup', 'rvm:install_ruby'

set :application, "XingCloud-Analytic-2.0"
set :repository,  "git@github.com:XingCloud/XA-Analytics.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# task :stage do
  role :web, "app@a.xingcloud.com", "app@at.xingcloud.com"                          # Your HTTP server, Apache/etc
  role :app, "app@a.xingcloud.com", "app@at.xingcloud.com"                      # This may be the same as your `Web` server
  role :db, "app@a.xingcloud.com", :primary => true # This is where Rails migrations will run
  role :resque_worker, "app@a.xingcloud.com", "app@at.xingcloud.com"
  role :resque_scheduler, "app@a.xingcloud.com", "app@at.xingcloud.com"
# end

#role :web, "app@a.xingcloud.com"                          # Your HTTP server, Apache/etc
#role :app, "app@a.xingcloud.com"                      # This may be the same as your `Web` server
#role :db, "app@a.xingcloud.com", :primary => true # This is where Rails migrations will run
#role :resque_worker, "app@a.xingcloud.com"
#role :resque_scheduler, "app@a.xingcloud.com"

# task :production do
#   role :web, "app@p.xingcloud.com"
#   role :app, "app@p.xingcloud.com"
#   role :db,  "app@p.xingcloud.com", :primary => true
# end


set :user, "app"
set :use_sudo, false
set :deploy_to, "/home/app/apps/analytic2.0"

set :branch, "master"
set :git_shallow_clone, 1
set :scm_verbose, true
set :deploy_via, :remote_cache
set :workers, { "*" => 5 }

task :custom_symlink do
  
  %w(tmp log).each do |dir|
    run "cd #{release_path} && rm -rf #{dir} && ln -sf #{shared_path}/#{dir} ."
  end
  
  %w(database app_config private_pub private_pub_thin resque_schedule).each do |config_file|
    run "cd #{release_path} && rm -rf config/#{config_file}.yml && ln -sf #{shared_path}/config/#{config_file}.yml config/#{config_file}.yml"
  end
  
end


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :private_pub do
  desc "Start private_pub server"
  task :start do
    run "cd #{current_path};RAILS_ENV=production bundle exec thin -C config/private_pub_thin.yml start"
  end

  desc "Stop private_pub server"
  task :stop do
    run "cd #{current_path};RAILS_ENV=production bundle exec thin -C config/private_pub_thin.yml stop"
  end

  desc "Restart private_pub server"
  task :restart do
    run "cd #{current_path};RAILS_ENV=production bundle exec thin -C config/private_pub_thin.yml restart"
  end
end

namespace :sake do
  desc "Run a task on a remote server."
  # run like: cap sake:invoke task="xxx"
  task :invoke do
    run("cd #{deploy_to}/current && bundle exec rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end

before "deploy:finalize_update", "custom_symlink"
after "deploy:restart", "resque:restart"
after "deploy:restart", "resque:scheduler:restart"
after "deploy:restart", "private_pub:restart"
