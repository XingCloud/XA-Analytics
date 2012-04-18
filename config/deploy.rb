set :application, "XingCloud-Analytic-2.0"
set :repository,  "git@github.com:fangjian601/XingCloud-Analytics.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# task :stage do
  role :web, "app@119.254.28.37"                          # Your HTTP server, Apache/etc
  role :app, "app@119.254.28.37"                      # This may be the same as your `Web` server
  role :db,  "app@119.254.28.37"    , :primary => true # This is where Rails migrations will run
# end

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

default_environment["PATH"] = "/sbin:/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/app/bin:/usr/local/sbin:/usr/sbin:"

task :custom_symlink do
  
  %w(tmp log).each do |dir|
    run "cd #{release_path} && rm -rf #{dir} && ln -sf #{shared_path}/#{dir} ."
  end
  
  %w(database app_config).each do |config_file|
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

before "deploy:finalize_update", "custom_symlink"
