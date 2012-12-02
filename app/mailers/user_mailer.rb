class UserMailer < ActionMailer::Base
  
  default from: "john@fnnny.com"
  
  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.display_name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "[#{configatron.app_name}] Welcome to Fnnny, motherfucker!")
  end
  
  def new_follow_email(user, follower)
    @user = user
    @follower = follower
    email_with_name = "#{@user.display_name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "[#{configatron.app_name}] #{@follower.display_name} is following you!")
  end
    
end