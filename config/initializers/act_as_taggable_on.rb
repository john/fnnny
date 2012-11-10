# from: http://stackoverflow.com/questions/4982589/creating-url-slugs-for-tags-with-acts-as-taggable-on

# act_as_taggable_on.rb
ActsAsTaggableOn::Tag.class_eval do
  
  extend FriendlyId
  friendly_id :name, use: :slugged

end