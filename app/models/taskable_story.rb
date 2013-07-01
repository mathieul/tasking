# == Schema Information
#
# Table name: taskable_stories
#
#  id         :integer          not null, primary key
#  status     :string(255)      default("draft"), not null
#  row_order  :integer          not null
#  story_id   :integer          not null
#  sprint_id  :integer          not null
#  team_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class TaskableStory < ActiveRecord::Base
  VALID_STATUSES = %w[draft tasked completed accepted]

  belongs_to :team
  belongs_to :owner, class_name: "Teammate"
  belongs_to :story,  touch: true
  belongs_to :sprint, touch: true
  has_many   :tasks, -> { ranked }, dependent: :destroy

  validates :status,    presence: true,
                        inclusion: {in: VALID_STATUSES, allow_nil: true}
  validates :row_order, presence: true
  validates :story,     presence: true
  validates :sprint,    presence: true
  validates :team,      presence: true

  delegate :description, to: :story

  def description=(description)
    story.update(description: description)
  end
end
