require "csv"

module DataExchange
  class ExportTeammatesCsv
    HEADER = %W[name color initials]

    def run(_, filter)
      CSV.generate do |csv|
        csv << HEADER
        Teammate
          .where(filter)
          .order(name: :asc)
          .pluck(*HEADER).each { |values| csv << values }
      end
    end
  end
end
