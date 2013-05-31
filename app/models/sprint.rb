class Sprint < ActiveRecord::Base
  VALID_STATUSES = %w[draft planned in_progress canceled completed]
  belongs_to :team
  has_many :stories, dependent: :nullify

  validates :projected_velocity, presence: true,
                                 numericality: {only_integer: true,
                                                greater_than: 0,
                                                allow_nil: true}
  validates :status, presence: true,
                     inclusion: {in: VALID_STATUSES, allow_nil: true}
  validates :start_on, presence: true
  validates :end_on, presence: true
  validates :team, presence: true
  validates :stories, presence: true
end
