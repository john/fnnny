source 'https://rubygems.org'

gem 'acts_as_follower'
gem 'acts-as-taggable-on'
gem 'addressable'
gem 'airbrake'
gem 'backup', :require => false
gem 'bootstrap-sass' #, :git => 'https://github.com/john/bootstrap-sass' # to address: https://github.com/twitter/bootstrap/issues/4756#issuecomment-9952781
gem 'carrierwave'
gem 'cloudinary'
gem 'configatron', :git => 'https://github.com/mikepb/configatron'
gem 'devise'

# screws up torquebox messaging with this exception:
# 10:11:46,719 ERROR [org.torquebox.messaging] (Thread-1 (HornetQ-client-global-threads-592053317)) Unexpected error in /queues/torquebox/fnnny/tasks/torquebox_backgroundable.TorqueBox::Messaging::BackgroundableProcessor: org.jruby.exceptions.RaiseException: (ArgumentError) undefined class/module Item::FriendlyIdActiveRecordRelation
# at org.jruby.RubyMarshal.load(org/jruby/RubyMarshal.java:148) [jruby.jar:]
gem 'friendly_id'

gem 'haml'
gem 'haml-rails'
gem 'humane-rails'
gem 'i18n'
gem 'jquery-rails'
gem 'koala'
gem 'mailboxer'
gem 'omniauth-facebook'
gem 'public_activity'
gem 'rack-canonical-host'
gem 'rails', '3.2.9'
gem 'strong_parameters'
gem 'thumbs_up', git: 'https://github.com/john/thumbs_up'
gem 'torquebox', "2.2.0"
gem 'useragent'
gem 'will_paginate'

platforms :ruby do
  gem 'mysql2'
end

platforms :jruby do
  gem 'activerecord-jdbcmysql-adapter'
  gem 'jdbc-mysql'
  # gem 'jruby-openssl'
  # gem 'warbler'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails' #,   '~> 3.2.3'
  gem 'uglifier' #, '>= 1.0.3'
  # gem 'coffee-rails', '~> 3.2.1'
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  # gem 'therubyrhino', :platforms => :jruby
end

group :development do
  gem 'capistrano'
  gem 'jruby-lint'
  gem 'seed_dump'
  
  gem 'trinidad', :require => nil, :platforms => :jruby
  gem 'thin', :require => nil, :platforms => :ruby
  
  # gem 'capistrano_colors'
  # gem 'colored'
  # gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
  # gem 'spork'
  # gem 'sprite-factory'
  # gem 'chunky_png'
end

group :test do
  gem 'factory_girl_rails' #, :require => false
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'shoulda-matchers' # https://github.com/jimweirich/rake/issues/51 (read bottom)
  
  # gem 'turn', :require => false # Pretty printed test output
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'