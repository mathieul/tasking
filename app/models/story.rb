class Story < ActiveRecord::Base
  include RankedModel
  ranks :row_order

  belongs_to :tech_lead, class_name: "Teammate"
  belongs_to :product_manager, class_name: "Teammate"

  validates :points, presence: true
  validates :description, presence: true
end
