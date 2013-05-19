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
  end
end
