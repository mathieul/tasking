# == Schema Information
#
# Table name: tasks
#
#  id                :integer          not null, primary key
#  description       :string(255)      not null
#  hours             :decimal(5, 2)    default(1.0), not null
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

  belongs_to :taskable_story, touch: true
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

  def progress!
    done_index = taskable_story.tasks.pluck("status").find_index { |status| status == "done" }
    done_index = done_index ? (done_index - 1) : :last
    update!(row_order_position: done_index, status: "in_progress")
  end

  def complete!
    update!(status: "done", hours: 0, row_order_position: :last)
  end

  def timed_description=(timed_description)
    matched = timed_description.match(/^(.*)\s+(([\d\.]+)\s*h?)$/)
    self.description, self.hours = matched ? matched.values_at(1, 3) : [timed_description.strip, 0]
  end
end
