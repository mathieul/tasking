class TeammateForm
  TEAMMATE_ATTRIBUTES = %w[name roles color initials]

  include ActiveModel::Model

  attr_accessor :teammate_id, :name, :roles, :email, :color, :initials

  validates :name, presence: true
  validates :color, presence: true

  def self.model_name
    @_model_name ||= ActiveModel::Name.new(self, nil, "teammate")
  end

  def self.from_teammate(teammate)
    attributes = teammate.attributes.slice(*TEAMMATE_ATTRIBUTES)
    attributes["email"] = teammate.account_email
    attributes["teammate_id"] = teammate.id
    new(attributes)
  end

  def submit(scope: nil)
    return false unless valid?
    raise ArgumentError, "missing mandatory team scope" if scope.nil?
    teammate = scope.teammates.find(teammate_id) if teammate_id.present?
    if teammate
      teammate.update(get_attributes)
    else
      scope.teammates.create(get_attributes)
    end
  end

  private

  def get_attributes
    TEAMMATE_ATTRIBUTES.each.with_object({}) do |name, attributes|
      value = send(name)
      attributes[name] = send(name) unless value.nil?
    end
  end
end
