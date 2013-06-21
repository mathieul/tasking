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

  belongs_to :story, touch: true
  belongs_to :sprint, touch: true
  belongs_to :team
  has_many   :tasks, -> { ranked }

  validates :status,    presence: true,
                        inclusion: {in: VALID_STATUSES, allow_nil: true}
  validates :row_order, presence: true
  validates :story,     presence: true
  validates :sprint,    presence: true
  validates :team,      presence: true
end
