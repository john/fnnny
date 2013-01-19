require 'bundler'
Bundler.require(:deploy)

# ?
# rvm use ruby-1.9.3-p194

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
    
    # FOR local vagrant VM
    # host = "localhost"
    # user = "vagrant"
    # port = 2222
    # keys = ["~/.vagrant.d/insecure_private_key"]
    
    # FOR EC2
    host = "ec2-23-20-128-160.compute-1.amazonaws.com"
    user = "ubuntu"
    port = 22
    keys = ["~/.ssh/id_rsa"]
    
    puts "about to create new warble task"
    Warbler::Task.new(:warble)
    
    puts "about to invoke warble"
    Rake::Task['warble'].invoke
    
    puts "about to start first ssh..."
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
      
      ssh.exec! "sudo export PATH=$PATH:/opt/jruby/bin"
      ssh.exec! "sudo export RAILS_ENV=production"
      out = ssh.exec! "sudo env PATH=$PATH jruby -v; echo $PATH; cd /opt/jruby-1.7.2/bin; pwd; sudo env PATH=$PATH jruby -S gem install warbler-exec"
      puts "gem install output: #{out}"
      
      out = ssh.exec! "cd ~/deploy; sudo env PATH=$PATH jruby -S warbler-exec fnnny.war bin/rake db:migrate"
      puts "gem install output: #{out}"
      
      out = ssh.exec! "cd; sudo mv deploy/funny.war /var/lib/tomcat7/webapps/"
      puts 'Deployment complete!'
      
      puts "warbler-exec db:migrate: DONE!"
    end
    
    
  end
  
end