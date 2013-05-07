class Account < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, on: :create}, allow_nil: true
end
