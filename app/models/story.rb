# == Schema Information
#
# Table name: stories
#
#  id                 :integer          not null, primary key
#  description        :text             default("As a role\nI can do something\nso I get a benefit"), not null
#  points             :integer          default(3), not null
#  row_order          :integer          not null
#  tech_lead_id       :integer
#  product_manager_id :integer
#  business_driver    :string(255)
#  spec_link          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  team_id            :integer          not null
#  sprint_id          :integer
#

class Story < ActiveRecord::Base
  VALID_POINTS = [0, 1, 2, 3, 5, 8, 13, 21]

  include RankedModel
  ranks :row_order, with_same: "team_id"

  belongs_to :team
  belongs_to :tech_lead, class_name: "Teammate"
  belongs_to :product_manager, class_name: "Teammate"
  belongs_to :sprint

  validates :points,      presence: true, inclusion: VALID_POINTS
  validates :description, presence: true
  validates :team,        presence: true

  delegate :name, to: :tech_lead, prefix: true, allow_nil: true
  delegate :name, to: :product_manager, prefix: true, allow_nil: true

  scope :ranked, -> { rank(:row_order) }
  scope :backlogged, -> { where(sprint_id: nil) }
  scope :sprinted, ->(sprint) { where(sprint_id: sprint.respond_to?(:id) ? sprint.id : sprint) }
end
