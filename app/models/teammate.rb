class Teammate < ActiveRecord::Base
  belongs_to :account

  validates :name, presence: true, uniqueness: true
  validates :roles, presence: {message: "can't be empty"}

  scope :with_role, -> (role) { where("roles @> '{#{role.inspect}}'") }
  scope :tech_leads, -> { with_role("tech_lead").order("name") }
  scope :product_managers, -> { with_role("product_manager").order("name") }
end
