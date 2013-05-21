require 'spec_helper'

describe Team do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:team)).to be_valid
    end

    it "is not valid without a name" do
      team = build(:team, name: nil)
      expect(team).to have(1).error_on(:name)
    end

    it "is not valid without a unique name" do
      create(:team, name: "Uniquely Yours")
      team = build(:team, name: "Uniquely Yours")
      expect(team).to have(1).error_on(:name)
    end

    it "is not valid without a projected velocity" do
      team = build(:team, projected_velocity: nil)
      expect(team).to have(1).error_on(:projected_velocity)
      team.projected_velocity = "blah"
      expect(team).to have(1).error_on(:projected_velocity)
    end
  end

  context "associations" do
    it "has many accounts" do
      team = create(:team, name: "dev")
      account = create(:account, team: team)
      expect(Team.find_by(name: "dev").accounts.to_a).to eq([account])
    end

    it "has many teammates" do
      team = create(:team, name: "dev")
      teammate = create(:teammate, team: team)
      expect(Team.find_by(name: "dev").teammates.to_a).to eq([teammate])
    end

    it "has many stories" do
      team = create(:team, name: "dev")
      story = create(:story, team: team)
      expect(Team.find_by(name: "dev").stories.to_a).to eq([story])
    end
  end
end
