require 'spec_helper'

describe ExportService do
  include SharedHelpers

  let(:team)   { create(:team) }
  let(:export) { ExportService.new(team: team) }

  context "teammate CSV file" do
    pending
  end
end
