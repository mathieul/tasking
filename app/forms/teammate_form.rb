class TeammateForm
  TEAMMATE_ATTRIBUTES = %i[name roles color initials]

  include Virtus
  include ActiveModel::Model
  include Rails.application.routes.url_helpers

  attr_reader :teammate, :attributes_initialized

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

  def self.from_teammate(source)
    attributes = source.attributes.symbolize_keys.slice(*TEAMMATE_ATTRIBUTES)
    new(attributes.merge(
      email: source.account_email,
      teammate_id: source.id
    ))
  end

  def initialize(params = {})
    super
    @attributes_initialized = TEAMMATE_ATTRIBUTES & params.keys.map(&:to_sym)
  end

  def path
    polymorphic_path(target)
  end

  def method
    persisted? ? :patch : :post
  end

  def submit(scope: nil)
    return false unless valid?
    raise ArgumentError, "missing mandatory team scope" if scope.nil?
    if create_or_update_teammate(scope).valid?
      set_teammate_account(scope)
    else
      false
    end
  end

  def persisted?
    teammate_id.present?
  end

  private

  def target
    teammate_id.present? ? Teammate.find(teammate_id) : Teammate.new
  end

  def create_or_update_teammate(team)
    teammate = team.teammates.find(teammate_id) if teammate_id.present?
    teammate_attributes = attributes.slice(*attributes_initialized)
    if teammate
      teammate.update(teammate_attributes)
    else
      teammate = team.teammates.create(teammate_attributes)
    end
    @teammate = teammate
  end

  def find_or_create_account(team)
    account = Account.find_by(email: email)
    if account && (account.teammate.present? || account.team != team)
      errors.add(:base, "account #{email} is already in use")
      nil
    else
      account || team.accounts.create(email: email)
    end
  end

  def set_teammate_account(scope)
    return true if teammate.nil? || email.blank?
    if (account = find_or_create_account(scope))
      teammate.account = account
      teammate.save
    else
      false
    end
  end
end
