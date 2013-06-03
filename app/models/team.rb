# == Schema Information
#
# Table name: teams
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  projected_velocity :integer          default(1)
#  created_at         :datetime
#  updated_at         :datetime
#

class Team < ActiveRecord::Base
  has_many :accounts, dependent: :destroy
  has_many :teammates, -> { order(name: :asc) }, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :sprints, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :projected_velocity, presence: true,
                                 numericality: {only_integer: true, allow_nil: true}

  def sprint_duration
    14.days
  end
end
