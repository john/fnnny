FactoryGirl.define do
  
  factory :item do
    name 'Purrsonals'
    description 'The Cat Lovers Social Network'
    url 'http://www.purrsonals.com/'
    
    after(:build) do |item|
      user = FactoryGirl.build(:user)
      user.email = "phu_#{20+Random.rand(11)}@blarg.com"
      user.save!
      item.user_id = user.id
      item.save!
    end
  end
  
end