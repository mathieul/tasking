class EmailService
  attr_reader :mailer, :email_kind

  def initialize(options = {})
    mailer_kind, @email_kind = options.first
    @mailer = "#{mailer_kind}_mailer".classify.constantize
  end

  def deliver(options = {})
    mail = mailer.public_send(email_kind, options)
    mail.deliver
  end
end
