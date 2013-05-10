class Account < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}, presence: {on: :create}

  before_create :generate_auth_token

  def generate_token(field)
    begin
      write_attribute(field, SecureRandom.urlsafe_base64)
    end while Account.exists?(field => read_attribute(field))
    self
  end

  def send_password_reset!
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    EmailService.new(account: :password_reset).deliver(id: id)
  end

  private

  def generate_auth_token
    generate_token(:auth_token)
  end
end
