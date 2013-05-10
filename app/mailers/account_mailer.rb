class AccountMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.account_mailer.password_reset.subject
  #
  def password_reset(id: nil)
    @account = Account.find(id)
    mail to: @account.email, subject: "Password reset"
  end

  def activate(id: nil)
    @account = Account.find(id)
    mail to: @account.email, subject: "Confirm account"
  end
end
