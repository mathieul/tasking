class Account < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, on: :create}, allow_nil: true

  before_create :generate_auth_token

  def generate_token(field)
    begin
      write_attribute(field, SecureRandom.urlsafe_base64)
    end while Account.exists?(field => read_attribute(field))
  end

  private

  def generate_auth_token
    generate_token(:auth_token)
  end
end
