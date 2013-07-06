require "csv"

module DataExchange
  class ImportTeammatesCsv
    MANDATORY = ["name", "color"]

    def run(content, common_attributes)
      CSV.parse(content, headers: true) do |csv|
        attributes = csv.to_hash
        unless (MANDATORY - attributes.keys).empty?
          raise ArgumentError, "missing mandatory attributes: #{MANDATORY.join(", ")}"
        end
        create_teammate(csv.to_hash, common_attributes)
      end
    end

    private

    def create_teammate(requested, common_attributes)
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
