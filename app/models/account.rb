# == Schema Information
#
# Table name: accounts
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  password_digest        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  activation_token       :string(255)
#  activated_at           :datetime
#  team_id                :integer          not null
#

class Account < ActiveRecord::Base
  has_secure_password

  belongs_to :team

  validates :email,    presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}, presence: {on: :create}
  validates :team,     presence: true

  before_create :generate_auth_token
  before_create :generate_activation_token

  accepts_nested_attributes_for :team

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

  def activate!
    update!(activated_at: Time.zone.now)
  end

  def activated?
    activated_at.present?
  end

  private

  def generate_auth_token
    generate_token(:auth_token)
  end

  def generate_activation_token
    generate_token(:activation_token)
  end
end
