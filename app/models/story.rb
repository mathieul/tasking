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
