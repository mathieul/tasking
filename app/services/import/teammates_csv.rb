require "csv"

module Import
  class TeammatesCsv
    MANDATORY = ["name", "color"]

    attr_reader :common_attributes

    def initialize(common_attributes)
      @common_attributes = common_attributes
    end

    def import(content)
      CSV.parse(content, headers: true) do |csv|
        attributes = csv.to_hash
        unless (MANDATORY - attributes.keys).empty?
          raise ArgumentError, "missing mandatory attributes: #{MANDATORY.join(", ")}"
        end
        create_teammate(csv.to_hash)
      end
    end

    private

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
end
