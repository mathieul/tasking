class Team < ActiveRecord::Base
  has_many :accounts, dependent: :destroy
  has_many :teammates, dependent: :destroy
  has_many :stories, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
