class UserMailer < ActionMailer::Base
  
  default from: "john@fnnny.com"
  
  def welcome_email(user)
    @user = user
    email_with_name = "#{@user.display_name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "[#{configatron.app_name}] Welcome to Fnnny, motherfucker!")
  end
  
  def invite_email(user, invitee)
    @user = user
    @invitee = invitee
    # email_with_name = "#{@invitee.first_name} #{@invitee.last_name} <#{@invitee.email}>"
    email_with_name = "#{@invitee.first_name} #{@invitee.last_name} <john@entelo.com>"
    mail(:to => email_with_name, :subject => "[#{configatron.app_name}] You are invited.")
  end
  
  def new_follow_email(user, follower)
    @user = user
    @follower = follower
    email_with_name = "#{@user.display_name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "[#{configatron.app_name}] #{@follower.display_name} is following you!")
  end
    
end
