class Story < ActiveRecord::Base
  belongs_to :tech_lead, class_name: "Teammate"
  belongs_to :product_manager, class_name: "Teammate"

  validates :points, presence: true
  validates :description, presence: true
  validates :sort, presence: true, numericality: {greater_than_or_equal_to: 0}
end
