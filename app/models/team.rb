class Team < ActiveRecord::Base
  has_many :accounts, dependent: :destroy
  has_many :teammates, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :sprints, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :projected_velocity, presence: true,
                                 numericality: {only_integer: true, allow_nil: true}
end
