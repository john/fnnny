# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

john = User.new( :first_name => 'John', :last_name => 'McGrath', :slug => 'john-mcgrath', :notifications => 'yes', :email => 'john@fnnny.com' )
john.save(:validate => false)

Authentication.create!(
              :user_id => john.id,
              :provider => 'facebook',
              :uid => '675003241',
              :access_token => 'AAAEMzrPeq5YBAEeh2k0UaIGgDs6VVxqFxqnVU844z6WsyCiMFxwnNIEb6jJrc6iy0M7aPv5YUk91wBnF3Dq7sf6BO29Rr8R3yeGUigZDZD' )

# created with seed_dump: http://rubydoc.info/gems/seed_dump/0.4.2/frames
# called thusly:
# rake db:seed:dump MODELS=Item APPEND=true

Item.create([
  { :user_id => 1, :name => "Cat Lovers Personals, Dating, Social Networking for Cat Lovers: PURRsonals.com", :slug => "cat-lovers-personals-dating-social-networking-for-cat-lovers-purrsonals-com", :description => "", :url => "http://www.purrsonals.com/", :image => "v1354231237/sbdckspwcmqtv2bjbhex.png", :original_image_url => "http://www.purrsonals.com/images/felineMagazine.jpg", :location => nil, :latitude => nil, :longitude => nil, :geo_quality => nil, :created_at => "2012-11-29 23:20:36", :updated_at => "2012-11-29 23:20:36" }
], :without_protection => true )


