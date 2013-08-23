class TeammateForm
  TEAMMATE_ATTRIBUTES = %i[name roles color initials]

  include Virtus
  include ActiveModel::Model

  attr_reader :teammate

  attribute :teammate_id, Integer
  attribute :name, String
  attribute :initials, String
  attribute :roles, Array[String]
  attribute :email, String
  attribute :color, String

  validates :name, presence: true
  validates :color, presence: true

  def self.model_name
    @_model_name ||= ActiveModel::Name.new(self, nil, "teammate")
  end

  def self.from_teammate(teammate)
    attributes = teammate.attributes.symbolize_keys.slice(*TEAMMATE_ATTRIBUTES)
    attributes["email"] = teammate.account_email
    attributes["teammate_id"] = teammate.id
    new(attributes)
  end

  def submit(scope: nil)
    return false unless valid?
    raise ArgumentError, "missing mandatory team scope" if scope.nil?
    if create_or_update_teammate(scope).valid?
      create_account(scope)
      true
    else
      false
    end
  end

  private

  def create_or_update_teammate(team)
    teammate = team.teammates.find(teammate_id) if teammate_id.present?
    teammate_attributes = attributes.slice(*TEAMMATE_ATTRIBUTES)
    if teammate
      teammate.update(teammate_attributes)
    else
      teammate = team.teammates.create(teammate_attributes)
    end
    @teammate = teammate
  end

  def create_account(team)
    return if teammate.nil? || email.blank?
    teammate.account = team.accounts.create(email: email)
  end
end
