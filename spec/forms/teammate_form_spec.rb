require 'spec_helper'

describe TeammateForm do
  context "validation" do
    it "is valid with valid attributes" do
      form = TeammateForm.new(valid_attributes)
      expect(form).to be_valid
    end

    it "is not valid without a name" do
      form = TeammateForm.new(valid_attributes.merge(name: nil))
      expect(form).to have(1).error_on(:name)
    end

    it "is not valid without a color" do
      form = TeammateForm.new(valid_attributes.merge(color: nil))
      expect(form).to have(1).error_on(:color)
    end
  end

  context "instanciation" do
    let(:teammate) { build(:teammate) }

    it "can be created from a teammate" do
      form = TeammateForm.from_teammate(teammate)
      expect(form.name).to eq(teammate.name)
      expect(form.email).to be_nil
    end

    it "can be created from a teammate with an account" do
      teammate.account = build(:account, email: "john@doe.com")
      form = TeammateForm.from_teammate(teammate)
      expect(form.email).to eq("john@doe.com")
    end

    it "knows the teammate id" do
      teammate.save!
      form = TeammateForm.from_teammate(teammate)
      expect(form.teammate_id).to eq(teammate.id)
    end
  end

  context "persistence" do
    let(:team) { create(:team) }

    it "returns true if the form is valid" do
      form = TeammateForm.new(name: "toto", color: "blue")
      expect(form.submit_for_team(team)).to be_true
    end

    it "returns false if the form isn't valid" do
      form = TeammateForm.new(name: "toto")
      expect(form.submit_for_team(team)).to be_false
    end

    it "creates a new teammate if it doesn't exist already" do
      form = TeammateForm.new(name: "toto", color: "baby-blue")
      form.submit_for_team(team)
      teammate = Teammate.find_by(name: "toto")
      expect(teammate.color).to eq("baby-blue")
      expect(teammate.team).to eq(team)
    end

    it "updates an existing teammate if it already exists" do
      teammate = create(:teammate, name: "jojo", team: team)
      form = TeammateForm.new(teammate_id: teammate.id, name: "titi", color: "baby-blue")
      expect { form.submit_for_team(team) }.not_to change { Teammate.count }
      teammate.reload
      expect(teammate.name).to eq("titi")
    end
  end

  private

  def valid_attributes
    {name: "Blah", color: "yellow"}
  end
end
