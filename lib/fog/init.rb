# IF running locally from fnnny root, switch to non-JRuby rvm:
# rvm use ruby-1.9.3-p194
# ruby lib/fog/init.rb

require 'rubygems'
require 'fog'

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
# puts "connection: #{connection.inspect}"
puts '---'


puts "bootstrappng server..."
server = connection.servers.bootstrap(  :private_key_path => '/Users/john/.ssh/id_rsa',
                                        :public_key_path => '/Users/john/.ssh/id_rsa.pub',
                                        :username => 'ubuntu',
                                        :image_id => @image_id,
                                        :flavor_id =>  @flavor_id )
                                        
puts "Public IP Address: #{server.public_ip_address}"
puts "Private IP Address: #{server.private_ip_address}"
# puts "server: #{server.inspect}" # show all server attributes
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
puts "apt-get update out: #{out}"
puts '--'
server.wait_for { ready? }

puts "running apt-get upgrade..."
out = server.ssh('sudo apt-get -y upgrade')
puts "apt-get upgrade out: #{out}"
puts '--'
server.wait_for { ready? }


###### Ruby (MRI)
puts "apt-getting ruby..."
out = server.ssh('sudo apt-get -y install ruby1.9.1')
puts "apt-get ruby output: #{out}"
puts '--'
server.wait_for { ready? }


###### Java (JDK 7)

puts "apt-getting openjdk-7-jdk..."
out = server.ssh('sudo apt-get -y install openjdk-7-jdk')
puts "apt-get openjdk-7-jdk output: #{out}"
puts '--'
server.wait_for { ready? }


###### Tomcat 7

puts "apt-getting tomcat7..."
out = server.ssh('sudo apt-get -y install tomcat7')
puts "apt-get tomcat7 output: #{out}"
puts '--'
server.wait_for { ready? }

puts "apt-getting tomcat7-admin..."
out = server.ssh('sudo apt-get -y install tomcat7-admin')
puts "apt-get tomcat7-admin output: #{out}"
puts '--'
server.wait_for { ready? }


###### Rubygems

out = server.ssh('wget http://rubyforge.org/frs/download.php/76073/rubygems-1.8.24.tgz')
puts "wget output: #{out}"
puts '--'
server.wait_for { ready? }

out = server.ssh('tar -xf rubygems-1.8.24.tgz')
puts "tar output: #{out}"
puts '--'
server.wait_for { ready? }

out = server.ssh('cd rubygems-1.8.24; sudo ruby setup.rb')
puts "setup.rb output: #{out}"
puts '--'
server.wait_for { ready? }


###### Puppet

out = server.ssh('sudo gem install puppet --no-ri --no-rdoc')
puts "gem output: #{out}"
puts '--'


# MUCH if not all of this is probably best done with puppet, since that would enforce the config.
# this'll do for now though.


###### JRuby (1.7.2)

# You need to cd to /opt first, otherwise the files in question end up in the ubutnu user's home dir
out = server.ssh('cd /opt; sudo wget http://jruby.org.s3.amazonaws.com/downloads/1.7.2/jruby-bin-1.7.2.tar.gz')
puts "wget jruby output: #{out}"
puts '--'
server.wait_for { ready? }

# out = server.ssh('sudo gunzip /opt/jruby-bin-1.7.2.tar.gz')
# puts "gunzip jruby output: #{out}"
# puts '--'
# server.wait_for { ready? }

out = server.ssh('cd /opt; sudo tar -zxvf jruby-bin-1.7.2.tar.gz')
puts "tar -zxvf jruby output: #{out}"
puts '--'
server.wait_for { ready? }

out = server.ssh('sudo ln -s /opt/jruby-1.7.2 /opt/jruby')
puts "ln -s  jruby output: #{out}"
server.wait_for { ready? }
puts '--'



# cloud-init already adds /etc/default/local with LANG="en_US.UTF-8", so this isn't necessary
# out = server.scp('/Users/john/projects/apps/fnnny/lib/fog/files/etc/default/locale', '/home/ubuntu')
# puts "scp output: #{out}"
# puts '--'

# WOULD like to do the two operations below in one step, but not sure how to sudo scp
out = server.scp('/Users/john/projects/apps/fnnny/lib/fog/files/etc/environment', '/home/ubuntu')
puts "scp output: #{out}"
puts '--'

out = server.ssh('sudo mv /home/ubuntu/environment /etc')
puts "mv: #{out}"
puts '--'

puts "ALL DONE! Instance setup, rebooting to pick up new /etc/environment, etc..."
out = server.ssh('sudo reboot')

# then sudo mv it into /etc

# TODO:
# JRuby?
# Tomcat, Torquebox, or other servlet container?
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
# ssh -i ~/.ssh/id_rsa ubuntu@ec2-184-73-87-200.compute-1.amazonaws.com