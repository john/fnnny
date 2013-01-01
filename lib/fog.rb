# IF running locally from fnnny root, switch to non-JRuby rvm:
# rvm use ruby-1.9.3-p194
# ruby fog.rb

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
puts "connection: #{connection.inspect}"
puts '---'

puts "bootstrappng server..."
server = connection.servers.bootstrap(  :private_key_path => '/Users/john/.ssh/id_rsa',
                                        :public_key_path => '/Users/john/.ssh/id_rsa.pub',
                                        :username => 'ubuntu',
                                        :image_id => @image_id,
                                        :flavor_id =>  @flavor_id )
                                        
puts "Public IP Address: #{server.ip_address}"
puts "Private IP Address: #{server.private_ip_address}"
puts "server: #{server.inspect}"
puts '---'

server.wait_for { ready? }
puts "server ready!"

# # Get a list of all the running servers/instances
# instance_list = connection.servers.all
# 
# num_instances = instance_list.length
# puts "We have " + num_instances.to_s()  + " servers"
# 
# server = instance_list[1]

# fog ssh into machine
# out = server.ssh(['pwd', 'whoami'])

# good examples of apt-getting crap via fog:
# http://artsy.github.com/blog/2012/01/31/beyond-heroku-satellite-delayed-job-workers-on-ec2/

out = server.ssh('sudo apt-get update')
out = server.ssh('sudo apt-get upgrade')
out = server.ssh('sudo apt-get install ruby1.9.1')
puts "apt-get ruby output: #{out}"

out = server.ssh('wget http://rubyforge.org/frs/download.php/76073/rubygems-1.8.24.tgz')
puts "wget output: #{out}"

out = server.ssh('tar -xf rubygems-1.8.24.tgz')
puts "tar output: #{out}"

out = server.ssh('ruby rubygems-1.8.24/setup.rb')
puts "setup.rb output: #{out}"

out = server.ssh('gem install puppet')
puts "gem output: #{out}"

# gem install puppet

# ssh over a puppet manifest

# run it

# et voila, a server