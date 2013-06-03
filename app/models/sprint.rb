# == Schema Information
#
# Table name: sprints
#
#  id                 :integer          not null, primary key
#  projected_velocity :integer          not null
#  measured_velocity  :integer
#  status             :string(255)      default("draft"), not null
#  start_on           :date
#  end_on             :date
#  team_id            :integer          not null
#  created_at         :datetime
#  updated_at         :datetime
#

class Sprint < ActiveRecord::Base
  VALID_STATUSES = %w[draft planned in_progress canceled completed]
  belongs_to :team
  has_many :taskable_stories, dependent: :destroy

  validates :projected_velocity, presence: true,
                                 numericality: {only_integer: true,
                                                greater_than: 0,
                                                allow_nil: true}
  validates :status, presence: true,
                     inclusion: {in: VALID_STATUSES, allow_nil: true}
  validates :start_on, presence: true
  validates :end_on, presence: true
  validates :team, presence: true

  after_create :create_taskable_stories

  def self.find_from_kind_or_id(kind_or_id)
    case kind_or_id.to_s
    when "last"    then find_last_sprint
    when "current" then find_current_sprint
    when "next"    then find_next_sprint
    else
      where(id: kind_or_id).take
    end
  end

  def self.find_last_sprint
    where("end_on < ?", Time.zone.today).order(end_on: :desc).first
  end

  def self.find_current_sprint
    today = Time.zone.today
    where("start_on <= ? AND end_on >= ?", today, today).first
  end

  def self.find_next_sprint
    where("start_on > ?", Time.zone.today).order(start_on: :asc).first
  end

  def story_ids=(ids)
    @story_ids = ids
    # # found = Story.find(ids).reject do |story|
    # #   current_id = story.team_id ? story.team_id : story.team.try(:id)
    # #   current_id != team_id
    # # end
    # Story.find(ids).each do |story|
    #   taskable_stories.build(story: story, team: team)
    # end
  end

  private

  def create_taskable_stories
    stories_to_task.each.with_index do |story, index|
      taskable_stories.create!(story: story, team: team, row_order: index)
    end
  end

  def stories_to_task
    return [] if @story_ids.nil?
    Story.find(@story_ids).reject do |story|
      current_id = story.team_id ? story.team_id : story.team.try(:id)
      current_id != team_id
    end
  end
end
