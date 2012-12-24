class UserMailer < ActionMailer::Base
  
  default from: "Fnnny <john@fnnny.com>"
  
  def welcome(user)
    @user = user
    email_with_name = "#{@user.display_name} <#{@user.email}>"
    puts "------------> sending welcome email to: #{email_with_name}"
    mail(:to => email_with_name, :subject => "[#{configatron.app_name}] Welcome to Fnnny, motherfucker!")
  end
  
  def follow(followed, follower)
    @followed = followed
    @follower = follower
    @user = followed
    
    email_with_name = "#{@followed.display_name} <#{@followed.email}>"
    puts "------------> sending follow email to: #{email_with_name}"
    mail(:to => email_with_name, :subject => "[#{configatron.app_name}] #{@follower.display_name} is following you!")
  end
  
  def comment(user, comment)
    puts "---> inside usermailer.comment"
    @user = user
    puts "---> @user is: #{@user.inspect}"
    @commenter = comment.user
    email_with_name = "#{@user.display_name} <#{@user.email}>"
    puts "------------> sending comment email to: #{email_with_name}"
    puts "comment is:"
    puts comment.inspect
    puts 'sending mail...'
    mail(:to => email_with_name, :subject => "[#{configatron.app_name}] #{@commenter.display_name} commented on your post")
  end
  
  def post(user, item)
  end
  
  def miss_you(user)
  end
  
end
