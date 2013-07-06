require 'spec_helper'

describe ImportService do
  include SharedHelpers

  let(:team)   { create(:team) }
  let(:import) { ImportService.new }

  context "teammate CSV file" do
    context "successful import" do
      let(:csv)  do
        file_content <<-EOC
        | name,color,initials
        | John,baby-blue,JCR
        | george oscar bluth,pink,
        | simple,dark-blue
        EOC
      end

      it "creates teammates from valid teammate rows" do
        expect { import.teammates(csv: csv, team: team) }.to change { Teammate.count }.by(3)
      end

      it "sets default attributes to each teammate" do
        import.teammates(csv: csv, team: team)
        expect(Teammate.find_by(name: "John").team).to eq(team)
      end

      it "titleizes the name" do
        import.teammates(csv: csv, team: team)
        expect(Teammate.find_by(name: "John")).to be_present
        expect(Teammate.find_by(name: "George Oscar Bluth")).to be_present
        expect(Teammate.find_by(name: "Simple")).to be_present
      end

      it "sets the color" do
        import.teammates(csv: csv, team: team)
        expect(Teammate.find_by(name: "John").color).to eq("baby-blue")
      end

      it "sets or guesses the initials" do
        import.teammates(csv: csv, team: team)
        expect(Teammate.find_by(name: "John").initials).to eq("JCR")
        expect(Teammate.find_by(name: "George Oscar Bluth").initials).to eq("GOB")
        expect(Teammate.find_by(name: "Simple").initials).to eq("SIM")
      end

      it "doesn't re-create existing teammates" do
        import.teammates(csv: csv, team: team)
        expect {
          csv2 = file_content <<-EOC
            | name,color,initials
            | george oscar bluth,pink,
          EOC
          import.teammates(csv:csv2, team: team)
        }.not_to raise_error
      end

      it "updates existing teammates" do
        import.teammates(csv: csv, team: team)
        csv2 = file_content <<-EOC
          | name,color,initials
          | george oscar bluth,purple,GB
        EOC
        import.teammates(csv:csv2, team: team)
        gob = Teammate.find_by(name: "George Oscar Bluth")
        expect(gob.color).to eq("purple")
        expect(gob.initials).to eq("GB")
      end
    end

    context "import with errors" do
      it "raises an error if the headers don't contain at least name and color" do
        expect {
          import.teammates(csv: "blah blah blah\ntiti", team: team)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
