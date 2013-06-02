# == Schema Information
#
# Table name: teammates
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  roles      :string(255)      default([])
#  account_id :integer
#  created_at :datetime
#  updated_at :datetime
#  team_id    :integer          not null
#  color      :string(255)      not null
#

class Teammate < ActiveRecord::Base
  ROLES = ["admin", "teammate", "tech_lead", "product_manager"]

  belongs_to :team
  belongs_to :account

  validates :name,  presence: true, uniqueness: true
  validates :roles, presence: {message: "can't be empty"}
  validates :color, presence: true
  validates :team,  presence: true

  scope :with_role, -> (role) { where("roles @> '{#{role.inspect}}'") }
  scope :tech_leads, -> { with_role("tech_lead").order("name") }
  scope :product_managers, -> { with_role("product_manager").order("name") }
end
