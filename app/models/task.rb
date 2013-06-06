# == Schema Information
#
# Table name: tasks
#
#  id                :integer          not null, primary key
#  description       :string(255)      not null
#  hours             :string(255)      not null
#  status            :string(255)      not null
#  row_order         :integer          not null
#  taskable_story_id :integer          not null
#  team_id           :integer          not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Task < ActiveRecord::Base
  include RankedModel
  ranks :row_order, with_same: "taskable_story_id"

  belongs_to :taskable_story
  belongs_to :team

  validates :description,    presence: true
  validates :hours,          presence: true,
                             numericality: {only_integer: true,
                                            greater_than_or_equal_to: 0,
                                            allow_nil: true}
  validates :status,         presence: true
  validates :taskable_story, presence: true
  validates :team,           presence: true

  scope :ranked, -> { rank(:row_order) }
end
