require 'bundler/capistrano'

# set :application, "Fnnny"
# set :repository,  "set your repository location here"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

server "ec2-23-23-46-250.compute-1.amazonaws.com", :app, :primary => true

ssh_options[:port] = 22
ssh_options[:keys] = "~/.ssh/id_rsa"

set :user, "ubuntu"
# set :group, "vagrant"
set :use_sudo, true

set :deploy_to, "/opt/trinidad"
set :application, "fnnny"
set :repository, "."
set :scm, :none
set :deploy_via, :copy
set :copy_exclude, [".git","log","tmp","*.box","*.war",".idea",".DS_Store"]

set :default_environment, 'PATH' => "/opt/jruby/bin:$PATH", 'JSVC_ARGS_EXTRA' => "-user ubuntu"
set :bundle_dir, ""
set :bundle_flags, "--system --quiet"


before "deploy:setup", "deploy:install_bundler"

namespace :deploy do
  
  task :install_bundler, :roles => :app do
    run "sudo gem install bundler"
  end
  
  task :start, :roles => :app do
    run "/etc/init.d/trinidad start"
  end
  
  task :stop, :roles => :app do end
  
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
end