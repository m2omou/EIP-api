class UserMailer < ActionMailer::Base
  default from: "no-reply@neerbyy.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  
  
  
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def alpha_user_confirm(mail_addr, uuid, url)
    @mail = mail_addr
    @unsubscribe_url =  url + "/alpha_users_destroy?email=" + mail_addr + "&uuid=" + uuid
    mail(:to => mail_addr, :subject => I18n.t("object_alpha_confirm"), :template => "alpha_user_confirm." + I18n.locale.to_s)
  end
end
