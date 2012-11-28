if Rails.env != 'test'
  email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))
  ActionMailer::Base.smtp_settings = email_settings[Rails.env] unless email_settings[Rails.env].nil?
end


# ActionMailer::Base.smtp_settings = {
#   
#   # SES
#   # :address        => "email-smtp.us-east-1.amazonaws.com",
#   # :port           => "465",
#   # :authentication => :plain,
#   # :openssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
#   # :enable_starttls_auto => true,
#   # :user_name      => "AKIAIFJRDXO4TBP2GRJQ",
#   # :password       => "Ah1c+DUnKmIu/ZQpfjkwNRvsT6Hkcd5SvCm56mkfJQZh"
#   
#   # SendGrid
#   # :user_name => "phu",
#   # :password => "bhar",
#   # :domain => "fnnny.com",
#   # :address => "smtp.sendgrid.net",
#   # :port => 587,
#   # :authentication => :plain,
#   # :enable_starttls_auto => true
#   
#   :address              => "smtp.gmail.com",
#   :port                 => 587,
#   :domain               => 'fnnny.com',
#   :user_name            => 'john@fnnny.com',
#   :password             => 'latte4me',
#   :authentication       => 'plain',
#   :enable_starttls_auto => true
#   
#  }