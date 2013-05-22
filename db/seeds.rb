# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# created with seed_dump: http://rubydoc.info/gems/seed_dump/0.4.2/frames
# called thusly:
# rake db:seed:dump MODELS=Item APPEND=true

# bundle exec rake db:drop; rake db:create; rake db:migrate; rake db:seed;

# john = User.new( :first_name => 'John', :last_name => 'McGrath', :slug => 'john-mcgrath', :notifications => 'yes', :email => 'john@fnnny.com' )
# john.save(:validate => false)

# Authentication.create!(
#               :user_id => john.id,
#               :provider => 'facebook',
#               :uid => '675003241',
#               :access_token => 'AAAEMzrPeq5YBAEeh2k0UaIGgDs6VVxqFxqnVU844z6WsyCiMFxwnNIEb6jJrc6iy0M7aPv5YUk91wBnF3Dq7sf6BO29Rr8R3yeGUigZDZD' )
#               


john = User.first

items_and_tags = [
  [
    { :name => "Neuticles",
      :description => "\"The revolutionary testicular implant procedure for pets... allows your pet to retain his natural look, self esteem and aids in the trauma associated with altering.\"",
      :url => "http://www.neuticles.com/",
      :original_image_url => 'http://www.supercoolpets.com/pictures/neuticles.jpg'
    }, 'cats, dogs, balls, medicine'
  ],
  [
    { :name => "PURRsonals.com: dating site for Cat Lovers: ",
      :description => "I have many questions about this, the first being, if you arrange an assignation on purrsonals, do you bring your cat?",
      :url => "http://www.purrsonals.com/",
      :original_image_url => "http://www.purrsonals.com/images/felineMagazine.jpg"
    }, 'cats, love, dating, sex, pussy'
  ],
  [
    { :name => "Eddie Izzard - Death Star Canteen",
      :description => "A Lego animation of comedian Eddie Izzard's \"Death Star canteen\" bit.",
      :url => "http://www.youtube.com/watch?v=Sv5iEK-IEzw"
    }, 'Eddie Izzard, Star Wars, Darth Vader, Lego, video'
  ],
  [
    { :name => "Liam Neeson's \"Life's Too Short\" Sketch",
      :description => "Liam Neeson comes to Ricky Gervais, Stephen Merchant, and Warwick Davis wanting to do comedy. This video is a combination of the hilarious excerpts from Liam Neeson's \"Life's Too Short\" sketch and the outtakes.",
      :url => "http://www.youtube.com/watch?v=lldrizLu_d8"
    }, 'Liam Neeson, Ricky Gervais, Stephen Merchant, Warwick Davis, Life\'s Too Short, video'
  ],
  [
    { :name => "Ted Nugent is a Mad Man",
      :description => "Ted Nugent interviewed by Bob Mack, from the Beastie Boys' <i>Grand Royal Magazine</i> , Issue 2, 1995. Archived by Glorious Noise.",
      :url => "http://gloriousnoise.com/2003/ted_nugent_is_a_mad_man",
      :original_image_url => "http://chainedandperfumed.files.wordpress.com/2009/01/grand-royal-2.jpg"}, 'Ted Nugent, Bob Mack, Beastie Boys, Grand Royal, interview'
  ],
  [
    { :name => "I'm Comic Sans, Asshole.",
      :description => "\"Listen up. I know the shit you've been saying behind my back. You think I'm stupid.\"",
      :url => "http://www.mcsweeneys.net/articles/im-comic-sans-asshole"
    }, 'fonts'
  ]
]


items_and_tags.each do |i|
  @item = Item.new(i[0])
  @item.user_id = john.id
  @item.user.tag(@item, :with => i[1], :on => :tags)
  @item.url = Addressable::URI.parse( @item.url ).normalize.to_s unless @item.url.blank?
  @item.remote_image_url = @item.original_image_url if @item.original_image_url.present?
  @item.save
end