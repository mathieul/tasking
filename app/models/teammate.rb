class Teammate < ActiveRecord::Base
  belongs_to :account

  validates :name, presence: true, uniqueness: true
  validates :roles, presence: {message: "can't be empty"}
end
