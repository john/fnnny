namespace :fog do
  
  desc "Provision new server"
  task(:new_server => :environment) do
    require 'fog'
    
    @aws_access_key_id = 'AKIAIHXOIL4LVGJVMXFA'
    @aws_secret_access_key = 'WQCE/VJnfqs3snotI9Ms3HVzFDAhnpkb9AIrGqpJ'
    
    # fake it until you make it
    # Fog.mock!
    
    # Set up a connection
    aws = Fog::Compute.new(
      :provider => 'AWS',
      :region=>'us-east-1',
      :aws_access_key_id => @aws_access_key_id,
      :aws_secret_access_key => @aws_secret_access_key
    )
    puts "aws: #{aws.inspect}"
    
    puts "about to create server"
    # ami-fd20ad94 = Ubuntu 12.04 64-bit ebs official: http://cloud-images.ubuntu.com/releases/precise/release/
    server = aws.servers.create(  :image_id => 'ami-fd20ad94',
                                  :flavor_id =>  't1.micro',
                                  :username => 'ubuntu')
                                  
    puts "server: #{server.inspect}"
    
    # Get a list of all the running servers/instances
    instance_list = aws.servers.all
    puts "instance_list: #{instance_list}"
    
    server = fog.servers.bootstrap( :private_key_path => '~/.ssh/id_rsa',
                                    :public_key_path => '~/.ssh/id_rsa.pub',
                                    :username => 'ubuntu',
                                    :image_id => 'ami-fd20ad94',
                                    :flavor_id =>  't1.micro')
                                    
    puts "server: #{server.inspect}"
    
    # wait for it to get online
    server.wait_for { ready? }
    
    # deploy to it? configure with puppet?
    
  end
  
  # tasks for: load balancer (elb), rds
  
end