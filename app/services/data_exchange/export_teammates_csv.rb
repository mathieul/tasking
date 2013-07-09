require "csv"

module DataExchange
  class ExportTeammatesCsv
    HEADER = %w[name roles color initials]

    def run(_, filter)
      CSV.generate do |csv|
        csv << HEADER
        Teammate
          .where(filter)
          .order(name: :asc)
          .pluck(*HEADER).each { |values| csv << normalize(values) }
      end
    end

    private

    def normalize(values)
      values.map do |value|
        case value
        when Array
          value.sort.join(" ")
        else
          value
        end
      end
    end
  end
end
