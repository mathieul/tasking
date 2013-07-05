require "csv"

class ImportService
  attr_reader :common_attributes

  def initialize(attributes = {})
    @common_attributes = attributes.stringify_keys
  end

  def teammates(content)
    CSV.parse(content, headers: true) do |csv|
      create_teammate(csv.to_hash)
    end
  end

  def create_teammate(requested)
    attributes = common_attributes.merge(roles: %w[teammate]).merge(requested)
    attributes["name"] = attributes["name"].titleize if attributes["name"]
    attributes["initials"] ||= teammate_initials(attributes["name"])
    teammate = Teammate.find_or_initialize_by(attributes.slice("name"))
    teammate.update!(attributes)
  end

  def teammate_initials(name)
    name ||= ""
    names = name.split(/\s/)
    case names.length
    when 0
      ""
    when 1 
      names.first[0..2].upcase
    else
      names.map(&:first).join.upcase
    end
  end
end
