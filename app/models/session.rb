class Session
  include ActiveModel::Model

  attr_accessor :email, :password, :remember_me

  validates :email, presence: true
  validates :password, presence: true
end
