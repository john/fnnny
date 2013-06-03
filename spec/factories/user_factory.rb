FactoryGirl.define do
  
  factory :user do
    first_name 'John'
    last_name 'McGrath'
    slug 'john-mcgrath'
    location 'Toledo, OH'
    email "john@fnnny.com"
    password 'phubhar'
    encrypted_password '123abc'
    # after(:create) do |user|
    #   org = FactoryGirl.create(:organization)
    #   affiliation = FactoryGirl.build(:affiliation, organization: org, user: user)
    #   affiliation.save!
    # end
  end
  
end