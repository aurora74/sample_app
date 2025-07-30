class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email,
         subject: Settings.email.subjects.account_activation,
         from: Settings.email.from_address
  end

  def password_reset user
    @user = user
    mail to: user.email,
         subject: Settings.email.subjects.password_reset,
         from: Settings.email.from_address
  end

  def password_reset_confirmation user
    @user = user
    mail to: user.email,
         subject: Settings.email.subjects.password_reset_confirmation,
         from: Settings.email.from_address
  end
end
