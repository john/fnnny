# TO RUN:

# prod:
# ruby lib/fog/init.rb -i t1.micro -r us-east-1 -p site.pp

# ruby lib/fog/init.rb -i c1.medium -r us-east-1 -p site.pp


# micro:
# t1.micro: 613MB, 1-2cu, ebs, 32/64bit, lowio

# 1st gen:
# m1.small: 1.7GB, 1cu, 160GB instance, 32/64bit, modio
# m1.medium: 3.75GB, 2cu, 410GB instance, 32/64bit, modio
# m1.large: 7.5GB, 4cu, 850GB instance, 64bit, highio
# m1.xlarge: 15GB, 8cu, 1.7TB instance, 64bit, highio

# 2nd gen:
# m3.xlarge: 15GB, 13cu, ebs, 64bit, modio
# m3.2xlarge: 30GB, 26 cu, ebs, 64bit, highio

# high-memory
# m2.xlarge: 17.1GB, 6.5cu, 420GB instance, 64bit, modio
# m2.2xlarge: 34.2GB, 13cu, 850GB instance, 64bit, highio
# m2.4xlarge: 68.4GB, 26cu, 1.7TB instance, 64bit, highio

# high-cpu
# c1.medium: 1.7GB, 5cu (2 vcores * 2.5cu), 350GB instance 32/64bit, modio
# c1.xlarge: 7GB, 20cu (8 vcores * 2.5cu), 1.7GB instance, 64bit, highio

# also available: cluster-compute, high-memory-cluster, cluster gpu, high-i/o, and high-storage instances.

# list of official ubuntu amis: http://cloud-images.ubuntu.com/releases/quantal/release/

require 'rubygems'
require 'optparse'
require 'fog'

@options = {}
# options[:"instance-type"] = ""
OptionParser.new do |opts|
  opts.banner = "Usage: ruby lib/fog/init.rb"
  
  # This displays the help screen, all programs are assumed to have this option.
  opts.on( '-h', '--help', 'Show this screen' ) { puts opts; exit }
  opts.on("-i", "--instance-type TYPE", "instance type, ie 'm1.small'") { |f| @options[:"instance-type"] = f }
  opts.on("-r", "--region REGION", "AWS region, ie 'us-west-2'") { |f| @options[:region] = f }
  opts.on("-p", "--puppet SCRIPT", "which puppet script to run, ie rails.pp, elasticsearch.pp") { |f| @options[:puppet] = f }
  
end.parse!

@fnnny_root = "/Users/john/projects/apps/fnnny"
@private_key_path = '/Users/john/.ssh/id_rsa'
@public_key_path = '/Users/john/.ssh/id_rsa.pub'

# fnnny account:
@aws_access_key_id = 'AKIAIHXOIL4LVGJVMXFA'
@aws_secret_access_key = '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'

aws_region = @options[:region]
puppet = @options[:puppet]
flavor_id = @options[:"instance-type"] # 1.7GB, good for web servers, workers

if aws_region == 'us-west-2'
  
  # instance types with instance storage
  if ['m1.small', 'm1.medium', 'm1.large', 'm1.xlarge', 'm2.2xlarge', 'm2.4xlarge', 'c1.medium', 'c1.xlarge'].include?(flavor_id)
    image_id = 'ami-6ab8325a' # = Ubuntu 12.10 64-bit instance
    
  # instance types with ebs storage
  elsif ['t1.micro', 'm3.xlarge', 'm3.2xlarge'].include?(flavor_id)
    image_id = 'ami-a4b83294' # = Ubuntu 12.10 64-bit ebs
    
  else
    puts "FAIL! instance type not supported (region: us-west-2)"
    exit 1
  end
  
elsif aws_region == 'us-east-1'
  
  # instance types with instance storage
  if ['m1.small', 'm1.medium', 'm1.large', 'm1.xlarge', 'm2.2xlarge', 'm2.4xlarge', 'c1.medium', 'c1.xlarge'].include?(flavor_id)
    image_id = 'ami-b8d147d1' # = Ubuntu 12.10 64-bit instance
    
  # instance types with ebs storage
  elsif ['t1.micro', 'm3.xlarge', 'm3.2xlarge'].include?(flavor_id)
    image_id = 'ami-0cdf4965' # = Ubuntu 12.10 64-bit ebs
    
  else
    puts "FAIL! instance type not supported (region: us-east-1)"
    exit 1
  end
  
else
  puts "FAIL! region not supported"
  exit 1
end

puts "aws_region: #{aws_region}"
puts "flavor_id: #{flavor_id}"
puts "image_id: #{image_id}"
puts "puppet: #{puppet}"

puts "creating connection..."
connection = Fog::Compute.new(
  :provider => 'AWS',
  :region => aws_region,
  :aws_access_key_id => @aws_access_key_id,
  :aws_secret_access_key => @aws_secret_access_key,
)

puts '---'

puts "bootstrappng server..."
server = connection.servers.bootstrap(  :private_key_path => @private_key_path,
                                        :public_key_path => @public_key_path,
                                        :username => 'ubuntu',
                                        :image_id => image_id,
                                        :flavor_id =>  flavor_id )
                                        
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


###### OS
puts "running apt-get update..."
out = server.ssh('sudo apt-get update')
# puts "apt-get update out: #{out}"
puts "apt-get update: DONE!"
puts '--'
server.wait_for { ready? }

puts "running apt-get upgrade..."
out = server.ssh('sudo apt-get -y upgrade')
puts "apt-get upgrade out: #{out}"
# puts "apt-get upgrade: DONE!"
puts '--'
server.wait_for { ready? }


###### Ruby (MRI)
puts "apt-getting ruby..."
out = server.ssh('sudo apt-get -y install ruby1.9.1-dev') # actually installs 1.9.3, not 1.9.1
# puts "apt-get ruby output: #{out}"
puts "apt-get ruby: DONE!"
puts '--'
server.wait_for { ready? }


###### Rubygems

out = server.ssh('wget http://rubyforge.org/frs/download.php/76073/rubygems-1.8.24.tgz')
puts "wget rubygems: DONE!"
puts '--'
server.wait_for { ready? }

out = server.ssh('tar -xf rubygems-1.8.25.tgz')
puts "untar rubygems: DONE!"
puts '--'
server.wait_for { ready? }

out = server.ssh('cd rubygems-1.8.25; sudo ruby setup.rb')
puts "setup.rb rubygems: DONE!"
puts '--'
server.wait_for { ready? }

# Ditch this when puppet 3.1 is released, fixing this: http://projects.puppetlabs.com/issues/9862
out = server.ssh('sudo groupadd puppet')
puts "added puppet group: DONE!"
puts '--'
server.wait_for { ready? }


###### Install Bundler
out = server.ssh("sudo gem install bundler --version '= 1.2.4' --no-ri --no-rdoc")
puts "gem install bundler: DONE! "
puts '--'
server.wait_for { ready? }

# You could use Puppet to install the es config file, if you wanted. It'd let you templatize it.

###### Install Puppet
out = server.ssh("sudo gem install --version '= 3.1.0' puppet --no-ri --no-rdoc")
puts "gem install puppet: DONE! "
puts '--'
server.wait_for { ready? }

###### Send over the manifests...
out = server.scp("#{@fnnny_root}/lib/puppet/", '/home/ubuntu/', :recursive => true)
puts "scp output: #{out}"
puts '--'
server.wait_for { ready? }

###### and RUN ONE!
cmd = "sudo env PATH=$PATH puppet apply --modulepath=puppet/modules puppet/manifests/#{puppet} --verbose"

out = server.ssh(cmd)
puts "puppet out: #{out}"
puts '--'
server.wait_for { ready? }

# TODO: CAN this script add the public url (or ip) of the just-created server to deploy.rb, and run deploy:setup?
# MAYBE this script should append the servername to a deployed_hosts file,
# which should itself be sourced by the cap script?


puts "ALL DONE! Instance setup, rebooting to pick up new /etc/environment, etc..."
out = server.ssh('sudo reboot')

# TODO:

# Logrotate?
# credentials.yml, possibly with new key? (http://sevos.github.com/2012/12/31/basics-of-fog-and-aws-for-rails-apps.html)
# new security group? (see above link)

# ssh -i ~/.ssh/id_rsa ubuntu@ec2-50-112-88-67.us-west-2.compute.amazonaws.com
