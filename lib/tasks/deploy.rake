require 'bundler'
Bundler.require(:deploy)

SSH_KEY = "~/.vagrant.d/insecure_private_key"

# def with_ssh
#   Net::SSH.start("localhost", "vagrant", {:port => 2222, :keys => [SSH_KEY]}) do |ssh|
#     puts "in with_ssh, about to yield"
#     puts "ssh in with_ssh is: #{ssh.inspect}"
#     yield
#     puts "in with_ssh, returned from yield"
#   end
# end

# def scp_upload(local_file, remote_file)
#   puts "inside scp_upload"
#   Net::SCP.upload!("localhost", "vagrant", local_file, remote_file, {
#     :ssh => {:port => 2222, :keys => [SSH_KEY]}
#   }) do |ch, name, sent, total|
#     puts "inside scp_upload block"
#     
#     print "\rCopying #{name}: #{sent}/#{total}"
#   end; print "\n"
# end

namespace :deploy do
  
  desc "Package and deploy app"
  task :war do
    
    # SUB this shit out for EC2...
    host = "localhost"
    user = "vagrant"
    port = 2222
    keys = [SSH_KEY]
    
    puts "about to create new warble task"
    Warbler::Task.new(:warble)
    
    puts "about to invoke warble"
    Rake::Task['warble'].invoke
    
    Net::SSH.start(host, user, {:port => port, :keys => keys}) do |ssh|
      puts "about to mkdir -p deploy/"
      ssh.exec! "mkdir -p deploy/"
      puts "mkdir -p deploy/: SUCCESS!"
      puts '---'
      
      puts "about to mkdir -p deploy/"
      ssh.exec! "mkdir -p deploy/"
      puts "mkdir -p deploy/: SUCCESS!"
      
      puts "about to ssh.exec! rm -rf"
      ssh.exec! "rm -rf deploy/*"
      puts "rm -rf deploy/*: SUCCESS!"
    end
    
    puts "inside scp_upload"
    Net::SCP.upload!(host, user, "fnnny.war", "deploy/", {:ssh => {:port => port, :keys => keys}}) do |ch, name, sent, total|
      # puts "\rCopying #{name}: #{sent}/#{total}"
    end; puts "\n"
    puts "scp_upload: DONE!"
    
    
    Net::SSH.start(host, user, {:port => port, :keys => keys}) do |ssh|
      # ssh.exec <<-SH do |ch, stream, data|
      #     cd deploy
      #     export PATH=$PATH:/opt/jruby/bin
      #     export RAILS_ENV=production
      #     sudo jgem install warbler-exec
      #     
      #     # Um, hey jackass: you can't run db:migrate when there's no fucking database present
      #     # DB creation needs to be done in fog.
      #     
      #     jruby -S warbler-exec twitalytics.war bin/rake db:migrate
      # SH
      # end
      
      ssh.exec! "cd deploy"
      ssh.exec! "export PATH=$PATH:/opt/jruby/bin"
      ssh.exec! "export RAILS_ENV=production"
      out = ssh.exec! "sudo jgem install warbler-exec"
      puts "output from 'sudo jgem install warbler-exec': #{out}"
      
      ssh.exec! "jruby -S warbler-exec twitalytics.war bin/rake db:migrate"
      
      puts "warbler-exec db:migrate: DONE!"
    end
    
    
  end
  
end