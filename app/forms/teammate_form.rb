class TeammateForm
  TEAMMATE_ATTRIBUTES = %w[name roles color initials]

  include ActiveModel::Model

  attr_accessor :name, :roles, :email, :color, :initials

  validates :name, presence: true
  validates :color, presence: true

  def self.model_name
    @_model_name ||= ActiveModel::Name.new(self, nil, "teammate")
  end

  def self.from_teammate(teammate)
    attributes = teammate.attributes.slice(*TEAMMATE_ATTRIBUTES)
    attributes["email"] = teammate.account_email
    new(attributes)
  end
end
