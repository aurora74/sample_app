class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email,
         subject: Settings.email.subjects.account_activation,
         from: Settings.email.from_address
  end
end
