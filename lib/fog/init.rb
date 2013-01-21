# IF running locally from fnnny root, switch to non-JRuby rvm:
# rvm use ruby-1.9.3-p194
# ruby lib/fog/init.rb

require 'rubygems'
require 'fog'

@fnnny_root = "/Users/john/projects/apps/fnnny"
@aws_access_key_id = 'AKIAIHXOIL4LVGJVMXFA'
@aws_secret_access_key = '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'

# # = small Ubuntuo 12.04 64-bit 
# @image_id = 'ami-d726abbe'
# @flavor_id = 'm1.small'

# = micro Ubuntu 12.04 (precise) 64-bit ebs official: http://cloud-images.ubuntu.com/releases/precise/release/
# @image_id = 'ami-fd20ad94'

# = micro Ubuntu 12.10 (quantal) 64-bit ebs official: http://cloud-images.ubuntu.com/releases/quantal/release/
@image_id = 'ami-7539b41c'

@flavor_id = 't1.micro'

puts "creating connection..."
connection = Fog::Compute.new(
  :provider => 'AWS',
  :region=>'us-east-1',
  :aws_access_key_id => @aws_access_key_id,
  :aws_secret_access_key => @aws_secret_access_key,
)

puts '---'

puts "bootstrappng server..."
server = connection.servers.bootstrap(  :private_key_path => '/Users/john/.ssh/id_rsa',
                                        :public_key_path => '/Users/john/.ssh/id_rsa.pub',
                                        :username => 'ubuntu',
                                        :image_id => @image_id,
                                        :flavor_id =>  @flavor_id )
                                        
puts "server: #{server.inspect}" # show all server attributes
puts '---'
puts "Public IP Address: #{server.public_ip_address}"
puts "Private IP Address: #{server.private_ip_address}"
puts '---'

server.wait_for { ready? }
puts "server ready!"

# Get a list of all the running servers/instances
instance_list = connection.servers.all
num_instances = instance_list.length
puts "We have " + num_instances.to_s()  + " servers"

# server = instance_list[0]




###### OS
puts "running apt-get update..."
out = server.ssh('sudo apt-get update')
# puts "apt-get update out: #{out}"
puts "agp-get update: DONE!"
puts '--'
server.wait_for { ready? }

puts "running apt-get upgrade..."
out = server.ssh('sudo apt-get -y upgrade')
# puts "apt-get upgrade out: #{out}"
puts "apt-get upgrade: DONE!"
puts '--'
server.wait_for { ready? }


###### Ruby (MRI)
puts "apt-getting ruby..."
out = server.ssh('sudo apt-get -y install ruby1.9.1-dev')
# puts "apt-get ruby output: #{out}"
puts "apt-get ruby: DONE!"
puts '--'
server.wait_for { ready? }


###### Rubygems

out = server.ssh('wget http://rubyforge.org/frs/download.php/76073/rubygems-1.8.24.tgz')
puts "wget rubygems: DONE!"
puts '--'
server.wait_for { ready? }

out = server.ssh('tar -xf rubygems-1.8.24.tgz')
puts "untar rubygems: DONE!"
puts '--'
server.wait_for { ready? }

out = server.ssh('cd rubygems-1.8.24; sudo ruby setup.rb')
puts "setup.rb rubygems: DONE!"
puts '--'
server.wait_for { ready? }

# Ditch this when puppet 3.1 is released, fixing this: http://projects.puppetlabs.com/issues/9862
out = server.ssh('sudo groupadd puppet')
puts "added puppet group: DONE!"
puts '--'
server.wait_for { ready? }

###### Install Bundler
# -v 1.2.3
out = server.ssh('sudo gem install bundler --no-ri --no-rdoc')
puts "gem install bundler: DONE! "
puts '--'

###### Install Puppet
# -v 3.0.2
out = server.ssh('sudo gem install puppet --no-ri --no-rdoc')
puts "gem install puppet: DONE! "
puts '--'


###### Send over a manifest...
out = server.scp("#{@fnnny_root}/puppet/", '/home/ubuntu/', :recursive => true)
puts "scp output: #{out}"
puts '--'

###### and RUN IT!

out = server.ssh('sudo env PATH=$PATH puppet apply --modulepath=puppet/modules puppet/manifests/site.pp')
puts "puppet out: #{out}"
puts '--'


# TODO: CAN this script add the public url (or ip) of the just-created server to deploy.rb, and run deploy:setup?



# 
# ###### Java (JDK 7)
# 
# puts "apt-getting openjdk-7-jdk..."
# out = server.ssh('sudo apt-get -y install openjdk-7-jdk')
# # puts "apt-get openjdk-7-jdk output: #{out}"
# puts "apt-get openjdk-7-jdk: DONE!"
# puts '--'
# server.wait_for { ready? }
# 
# 
# ###### Tomcat 7
# 
# puts "apt-getting tomcat7..."
# out = server.ssh('sudo apt-get -y install tomcat7')
# # puts "apt-get tomcat7 output: #{out}"
# puts "apt-get tomcat7: DONE!"
# puts '--'
# server.wait_for { ready? }
# 
# puts "apt-getting tomcat7-admin..."
# out = server.ssh('sudo apt-get -y install tomcat7-admin')
# # puts "apt-get tomcat7-admin output: #{out}"
# puts "apt-get tomcat7-admin: DONE!"
# puts '--'
# server.wait_for { ready? }
# 
# 
# 
# ###### JRuby (1.7.2)
# 
# # You need to cd to /opt first, otherwise the files in question end up in the ubutnu user's home dir
# out = server.ssh('cd /opt; sudo wget http://jruby.org.s3.amazonaws.com/downloads/1.7.2/jruby-bin-1.7.2.tar.gz')
# puts "wget jruby: DONE!"
# puts '--'
# server.wait_for { ready? }
# 
# # out = server.ssh('sudo gunzip /opt/jruby-bin-1.7.2.tar.gz')
# # puts "gunzip jruby output: #{out}"
# # puts '--'
# # server.wait_for { ready? }
# 
# out = server.ssh('cd /opt; sudo tar -zxvf jruby-bin-1.7.2.tar.gz')
# # puts "tar -zxvf jruby output: #{out}"
# puts "tar -zxvf jruby: DONE!"
# puts '--'
# server.wait_for { ready? }
# 
# out = server.ssh('sudo ln -s /opt/jruby-1.7.2 /opt/jruby')
# puts "ln -s  jruby output: #{out}"
# server.wait_for { ready? }
# puts '--'
# 
# 
# 
# 
# # drop and re-initiate connection, so that jruby is in the path...
# 
# 
# # install trinidad, using jruby
# out = server.ssh('sudo env PATH=$PATH /opt/jruby/bin/jruby -S gem install trinidad -v 1.4.4')
# puts "jruby -S gem install trinidad out: #{out}"
# 
# out = server.ssh('sudo env PATH=$PATH /opt/jruby/bin/jruby -S gem install trinidad_init_services -v 1.2.2')
# puts "jruby -S gem install trinidad_init_services out: #{out}"
# puts '--'
# server.wait_for { ready? }
# 
# # config and run trinidad_init_services
# 
# # WOULD like to do the two operations below in one step, but not sure how to sudo scp
# server.scp('/Users/john/projects/apps/fnnny/lib/fog/files/trinidad_config.yml', '/home/ubuntu')
# server.ssh('sudo mv /home/ubuntu/trinidad_config.yml /opt/trinidad')
# puts "/opt/trinidad/trinidad_config.yml in place..."
# puts '--'
# 
# 
# # cloud-init already adds /etc/default/local with LANG="en_US.UTF-8", so this isn't necessary
# # out = server.scp('/Users/john/projects/apps/fnnny/lib/fog/files/etc/default/locale', '/home/ubuntu')
# # puts "scp output: #{out}"
# # puts '--'
# 
# # WOULD like to do the two operations below in one step, but not sure how to sudo scp
# server.scp('/Users/john/projects/apps/fnnny/lib/fog/files/etc/environment', '/home/ubuntu')
# server.ssh('sudo mv /home/ubuntu/environment /etc')
# puts "/etc/environment in place..."
# puts '--'
# 
# puts "ALL DONE! Instance setup, rebooting to pick up new /etc/environment, etc..."
# out = server.ssh('sudo reboot')

# then sudo mv it into /etc

# TODO:

# ELB?
# Logrotate?
# Tune OpenJDK?
# credentials.yml, possibly with new key? (http://sevos.github.com/2012/12/31/basics-of-fog-and-aws-for-rails-apps.html)
# new security group? (see above link)

# gem install puppet

# ssh over a puppet manifest

# run it

# et voila, a server

# ssh in thusly:
# ssh -i ~/.ssh/id_rsa ubuntu@ec2-54-242-108-139.compute-1.amazonaws.com