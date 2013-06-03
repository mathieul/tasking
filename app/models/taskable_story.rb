# == Schema Information
#
# Table name: taskable_stories
#
#  id         :integer          not null, primary key
#  status     :string(255)      not null
#  row_order  :integer          not null
#  story_id   :integer          not null
#  sprint_id  :integer          not null
#  team_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class TaskableStory < ActiveRecord::Base
  belongs_to :story
  belongs_to :sprint
  belongs_to :team
  has_many   :tasks, -> { ranked }

  validates :status,    presence: true
  validates :row_order, presence: true
  validates :story,     presence: true
  validates :sprint,    presence: true
  validates :team,      presence: true
end
