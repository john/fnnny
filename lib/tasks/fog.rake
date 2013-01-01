namespace :fog do
  
  desc "Provision new server"
  task(:new_server => :environment) do
    require 'fog'
    
    @aws_access_key_id = 'AKIAIHXOIL4LVGJVMXFA'
    @aws_secret_access_key = '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'
    
    # = micro Ubuntu 12.04 64-bit ebs official: http://cloud-images.ubuntu.com/releases/precise/release/
    @image_id = 'ami-fd20ad94'
    @flavor_id = 't1.micro'
    
    # # = small Ubuntuo 12.04 64-bit 
    # @image_id = 'ami-d726abbe'
    # @flavor_id = 'm1.small'
    
    # fake it until you make it
    Fog.mock!
    
    # Set up a connection
    connection = Fog::Compute.new(
      :provider => 'AWS',
      :region=>'us-east-1',
      :aws_access_key_id => @aws_access_key_id,
      :aws_secret_access_key => @aws_secret_access_key,
    )
    
    
    
    # server = connection.servers.create(  :image_id => 'ami-fd20ad94',
    #                               :flavor_id =>  't1.micro',
    #                               :username => 'ubuntu',
    #                               :key_name => 'fnnnyec2' )
    
    server = connection.servers.bootstrap( :private_key_path => '/Users/john/.ssh/id_rsa',
                                    :public_key_path => '/Users/john/.ssh/id_rsa.pub',
                                    :username => 'ubuntu',
                                    :image_id => @image_id,
                                    :flavor_id =>  @flavor_id )
                                    
    # wait for it to get online
    server.wait_for { ready? }
    
    # you should then be able to ssh into the instance like this:
    # ssh -i /Users/john/.ec2/fnnnyec2.pem ubuntu@ec2-54-234-87-225.compute-1.amazonaws.com
    
    # so you can go in with the ec2 keys, but not the keys configured via fog. do you need to add the key you'll use with fog to ec2 via the dashboard?
    
    # TRY creating an instance with 'create' instead of 'bootstrap', see if you can ssh in
    
    # http://cloud-computing.learningtree.com/2010/09/24/understanding-amazon-ec2-security-groups-and-firewalls/
    # EVENTUALLY should have a load balancer open on port 80, which fronts nodes that are only open on port 22
    
    puts "------------> server: #{server.inspect}"
    puts "------------> instance_list: #{instance_list}"
    
    
    # Get a list of all the running servers/instances
    instance_list = connection.servers.all
    
    
    
    
    # deploy to it? configure with puppet?
    
    # I think this shuts it off without terminating it, but test.
    server.destroy
  end
  
  # tasks for: load balancer (elb), rds
  
end