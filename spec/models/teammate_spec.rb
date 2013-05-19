require 'spec_helper'

describe Teammate do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:teammate)).to be_valid
    end

    it "is not valid without a name" do
      teammate = build(:teammate, name: nil)
      expect(teammate).to have(1).error_on(:name)
    end

    it "has a unique name" do
      create(:teammate, name: "Unique Name")
      teammate = build(:teammate, name: "Unique Name")
      expect(teammate).to have(1).error_on(:name)
    end

    it "is not valid without at least one role" do
      teammate = build(:teammate, roles: [])
      expect(teammate).to have(1).error_on(:roles)
      teammate.roles << "engineer"
      expect(teammate).to be_valid
    end
  end

  context "associations" do
    it "belongs to an account" do
      teammate = build(:teammate, account: account = create(:account))
      expect(teammate.account).to eq(account)
    end

    it "must belong to a team" do
      teammate = build(:teammate, team: team = create(:team))
      expect(teammate.team).to eq(team)
      expect(teammate).to be_valid
      teammate.team = nil
      expect(teammate).not_to be_valid
    end
  end

  context "scopes" do
    it "scopes to teammates with role using #with_role" do
      create(:teammate, name: "pig", roles: ["tech_lead"])
      create(:teammate, name: "chicken", roles: ["stakeholder"])
      tech_leads = Teammate.with_role("tech_lead")
      expect(tech_leads.map(&:name)).to eq(["pig"])
    end
  end
end
