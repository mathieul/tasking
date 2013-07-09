require 'spec_helper'

describe DataExchangeService do
  include SharedHelpers

  let(:team)   { create(:team) }

  context "import teammate CSV file" do
    let(:import) { DataExchangeService.new.import }

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

      it "sets the roles to teammate" do
        import.teammates(csv: csv, team: team)
        expect(Teammate.find_by(name: "John").roles).to eq(["teammate"])
        expect(Teammate.find_by(name: "George Oscar Bluth").roles).to eq(["teammate"])
        expect(Teammate.find_by(name: "Simple").roles).to eq(["teammate"])
      end

      context "mandatory and optional columns" do
        it "requires columns name and colors" do
          expect { import.teammates(csv: "name\njoe", team: team) }.to raise_error(ArgumentError)
          expect { import.teammates(csv: "color\npink", team: team) }.to raise_error(ArgumentError)
          expect { import.teammates(csv: "name,color\njoe,pink", team: team) }.not_to raise_error
        end

        it "can import the initials" do
          import.teammates(csv: "name,color,initials\njoe,pink,JB", team: team)
          expect(Teammate.find_by(name: "Joe").initials).to eq("JB")
        end

        it "can import the roles" do
          import.teammates(csv: "name,color,roles\njoe,pink,product_manager admin", team: team)
          joe = Teammate.find_by(name: "Joe")
          expect(joe.roles).to include("product_manager")
          expect(joe.roles).to include("admin")
        end
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

      it "raises an error if the headers don't contain at least name and color" do
        expect {
          import.teammates(csv: "blah blah blah\ntiti", team: team)
        }.to raise_error(ArgumentError)
      end

      it "returns a hash with number of teammates added and updated" do
        result = import.teammates(csv: csv, team: team)
        expect(result).to eq(added: 3, updated: 0)
        csv2 = file_content <<-EOC
          | name,color,initials
          | george oscar bluth,purple,GB
          | james bond,black
        EOC
        result = import.teammates(csv:csv2, team: team)
        expect(result).to eq(added: 1, updated: 1)
      end
    end
  end

  context "export teammate CSV file" do
    let(:export) { DataExchangeService.new.export }
    let(:masada) { create(:team, name: "Masada") }

    it "exports the teammates for a team as CSV" do
      create(:teammate, name: "John Zorn", color: "black", initials: "JZO",
                        roles: %w[teammate product_manager])
      create(:teammate, name: "Greg Cohen", color: "pink", initials: "GCO",
                        roles: %w[tech_lead teammate])
      create(:teammate, name: "Dave Douglas", color: "baby-blue", initials: "DDO",
                        roles: %w[product_manager])
      create(:teammate, name: "Joey Baron", color: "purple", initials: "JBA",
                        roles: %w[teammate])
      expected_csv = file_content <<-EOC
        | name,roles,color,initials
        | Dave Douglas,product_manager,baby-blue,DDO
        | Greg Cohen,teammate tech_lead,pink,GCO
        | Joey Baron,teammate,purple,JBA
        | John Zorn,product_manager teammate,black,JZO
      EOC
      expect(export.teammates(:csv)).to eq(expected_csv)
    end

    it "selects teammates to export using the filter" do
      masada = create(:team, name: "Masada")
      create(:teammate, name: "Different Team")
      create(:teammate, name: "John Zorn", color: "black", initials: "JZO",
                        roles: %w[admin], team: masada)
      create(:teammate, name: "Another Team")
      expected_csv = file_content <<-EOC
        | name,roles,color,initials
        | John Zorn,admin,black,JZO
      EOC
      expect(export.teammates(:csv, team: masada)).to eq(expected_csv)
    end
  end
end
