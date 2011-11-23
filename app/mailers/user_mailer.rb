class UserMailer < ActionMailer::Base
  default :from => SYSTEM_MAILER

  def new_comment(comment)
    to = User.activated.collect{|u| u.email} - [comment.user.email, "smagnin.osteo@gmail.com"]
    @comment = comment
    mail(:to => to, :subject => "PMI2 - Nouveau commentaire sur le site")
  end
end