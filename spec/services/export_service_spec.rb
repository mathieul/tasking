require 'spec_helper'

describe ExportService do
  include SharedHelpers

  let(:team)   { create(:team) }
  let(:export) { ExportService.new }

  context "teammate CSV file" do
    it "exports the teammates for a team as CSV" do
      create(:teammate, name: "John Zorn", color: "black", initials: "JZO", team: team)
      expected_csv = file_content <<-EOC
        | name,color,initials
        | John Zorn,black,JZO
      EOC
      expect(export.teammates(:csv, team: team)).to eq(expected_csv)
    end
  end
end
