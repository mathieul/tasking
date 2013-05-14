class Story < ActiveRecord::Base
  VALID_POINTS = [0, 1, 2, 3, 5, 8, 13, 21]

  include RankedModel
  ranks :row_order

  belongs_to :tech_lead, class_name: "Teammate"
  belongs_to :product_manager, class_name: "Teammate"

  validates :points, presence: true, inclusion: VALID_POINTS
  validates :description, presence: true

  delegate :name, to: :tech_lead, prefix: true, allow_nil: true
  delegate :name, to: :product_manager, prefix: true, allow_nil: true
end
