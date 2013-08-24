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
#  initials   :string(255)      not null
#

class Teammate < ActiveRecord::Base
  ROLES  = %w[teammate tech_lead product_manager]
  COLORS = %w[baby-blue dark-beige dark-blue dark-green dark-purple light-green
              old-pink orange pink black purple red salmon yellow]

  belongs_to :team
  belongs_to :account

  validates :name,     presence: true, uniqueness: {case_sensitive: false}
  validates :initials, presence: true, uniqueness: {case_sensitive: false}
  validates :color,    presence: true,
                       inclusion: {in: COLORS, allow_nil: true}
  validates :team,     presence: true

  before_validation :set_initials_if_missing

  scope :with_role, -> (role) { where("roles @> '{#{role.inspect}}'") }
  scope :tech_leads, -> { with_role("tech_lead").order("name") }
  scope :product_managers, -> { with_role("product_manager").order("name") }

  delegate :email, to: :account, prefix: true, allow_nil: true

  private

  def set_initials_if_missing
    return if initials.present? || name.nil?
    names = name.split(/\s/)
    self.initials = case names.length
                    when 0
                      ""
                    when 1
                      names.first[0..2].upcase
                    else
                      names.map(&:first).join.upcase
                    end
  end
end
