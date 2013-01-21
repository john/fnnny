source 'https://rubygems.org'

gem 'acts_as_follower'
gem 'acts-as-taggable-on'
gem 'addressable'
gem 'airbrake'
gem 'backup', :require => false

# ffi-ncurses is a pure-ruby ncurses, required for capistrano on jruby
gem 'capistrano'
gem 'ffi-ncurses'

gem 'carrierwave'
gem 'cloudinary'
gem 'configatron', :git => 'https://github.com/mikepb/configatron'
gem 'devise'

# screws up torquebox messaging with this exception:
# 10:11:46,719 ERROR [org.torquebox.messaging] (Thread-1 (HornetQ-client-global-threads-592053317)) Unexpected error in /queues/torquebox/fnnny/tasks/torquebox_backgroundable.TorqueBox::Messaging::BackgroundableProcessor: org.jruby.exceptions.RaiseException: (ArgumentError) undefined class/module Item::FriendlyIdActiveRecordRelation
# at org.jruby.RubyMarshal.load(org/jruby/RubyMarshal.java:148) [jruby.jar:]
gem 'friendly_id'
gem 'get_back'
gem 'haml'
gem 'haml-rails'
gem 'humane-rails'
gem 'i18n'
gem 'jquery-rails'
gem 'json-jruby'
gem 'koala'
gem 'mailboxer'
gem 'omniauth-facebook'
gem 'public_activity'
gem 'rack-canonical-host'
gem 'rails', '3.2.11'
gem 'strong_parameters'
gem 'thumbs_up', git: 'https://github.com/john/thumbs_up'
gem 'useragent'
gem 'will_paginate'

# platforms :ruby do
#   gem 'mysql2'
# end

# platforms :jruby do
  gem 'jdbc-mysql'
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcmysql-adapter'
  gem 'trinidad'
  gem 'trinidad_diagnostics_extension'
  
  # quartz. not actually using this; comment out before deploying to prod
  # See JRuby deployment book for info
  # gem 'trinidad_scheduler_extension'
# end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'uglifier'
  # gem 'coffee-rails', '~> 3.2.1'
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  # gem 'therubyrhino', :platforms => :jruby
end

group :deploy do
  gem "net-ssh", :require => "net/ssh"
  gem "net-scp", :require => "net/scp"
  gem 'warbler'
end

group :development do
  gem 'capistrano', :require => false
  gem 'fog', :require => false
  gem 'jruby-lint', :require => false
  gem 'seed_dump', :require => false
  gem 'thin', :require => false, :platforms => :ruby
end

group :test do
  gem 'factory_girl_rails' #, :require => false
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'shoulda-matchers' # https://github.com/jimweirich/rake/issues/51 (read bottom)
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