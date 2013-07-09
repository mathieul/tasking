require "csv"

module DataExchange
  class ImportTeammatesCsv
    MANDATORY = ["name", "color"]

    def run(content, common_attributes)
      result = {added: 0, updated: 0}
      CSV.parse(content, headers: true) do |csv|
        attributes = csv.to_hash
        unless (MANDATORY - attributes.keys).empty?
          raise ArgumentError, "missing mandatory attributes: #{MANDATORY.join(", ")}"
        end
        operation = create_teammate(csv.to_hash, common_attributes)
        result[operation] += 1
      end
      result
    end

    private

    def create_teammate(requested, common_attributes)
      attributes = common_attributes.merge(roles: %w[teammate]).merge(requested)
      attributes["name"] = attributes["name"].titleize if attributes["name"]
      teammate = Teammate.find_or_initialize_by(attributes.slice("name"))
      result = teammate.new_record? ? :added : :updated
      teammate.update!(attributes)
      result
    end
  end
end
