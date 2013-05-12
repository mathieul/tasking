class Teammate < ActiveRecord::Base
  belongs_to :account

  validates :name, presence: true
  validates :roles, presence: {message: "can't be empty"}
  validate  :roles_are_valid

  private

  def roles_are_valid
    # errors.add(:roles, "")
  end
end
