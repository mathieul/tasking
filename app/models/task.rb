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
#  teammate_id       :integer
#

class Task < ActiveRecord::Base
  VALID_STATUSES = %w[todo in_progress done]

  include RankedModel
  ranks :row_order, with_same: "taskable_story_id"

  belongs_to :taskable_story
  belongs_to :team
  belongs_to :teammate

  validates :description,    presence: true
  validates :hours,          presence: true,
                             numericality: {greater_than_or_equal_to: 0,
                                            allow_nil: true}
  validates :status,         presence: true,
                             inclusion: {in: VALID_STATUSES, allow_nil: true}
  validates :taskable_story, presence: true
  validates :team,           presence: true

  scope :ranked, -> { rank(:row_order) }
end
