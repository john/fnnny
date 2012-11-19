namespace :images do
  
  # Gets new accounts by paginating through the Github search page and scraping.
  # bundle exec rake github:scrape --trace
  desc "Delete from Cloudinary"
  task(:clear_cloudinary => :environment) do
    Cloudinary::Uploader.destroy(public_id, options = {})
  end
  
end