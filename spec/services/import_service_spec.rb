require 'spec_helper'

describe ImportService do
  include SharedHelpers

  let(:team)   { create(:team) }
  let(:import) { ImportService.new(team: team) }

  context "teammate CSV file" do
    let(:csv)  do
      file_content <<-EOC
      | name,color,initials
      | John,baby-blue,JCR
      | george oscar bluth,pink,
      | simple,dark-blue
      EOC
    end

    it "creates teammates from valid teammate rows" do
      expect { import.teammates(csv) }.to change { Teammate.count }.by(3)
    end

    it "titleizes the name" do
      import.teammates(csv)
      expect(Teammate.find_by(name: "John")).to be_present
      expect(Teammate.find_by(name: "George Oscar Bluth")).to be_present
      expect(Teammate.find_by(name: "Simple")).to be_present
    end

    it "sets or guesses the initials" do
      import.teammates(csv)
      expect(Teammate.find_by(name: "John").initials).to eq("JCR")
      expect(Teammate.find_by(name: "George Oscar Bluth").initials).to eq("GOB")
      expect(Teammate.find_by(name: "Simple").initials).to eq("SIM")
    end
  end
end
