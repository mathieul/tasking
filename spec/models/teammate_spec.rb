require 'spec_helper'

describe Teammate do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:teammate)).to be_valid
    end

    it "is not valid without a name" do
      teammate = build(:teammate, name: nil)
      expect(teammate).not_to be_valid
      teammate.name = "Kirk"
      expect(teammate).to be_valid
    end

    it "has a unique name" do
      create(:teammate, name: "Unique Name")
      teammate = build(:teammate, name: "Unique Name")
      expect(teammate).not_to be_valid
      teammate.name += " #2"
      expect(teammate).to be_valid
    end

    it "is not valid without at least one role" do
      teammate = build(:teammate, roles: [])
      expect(teammate).not_to be_valid
      teammate.roles << "engineer"
      expect(teammate).to be_valid
    end
  end

  context "optional attributes" do
    it "can have an account" do
      teammate = build(:teammate, account: account = create(:account))
      expect(teammate.account).to eq(account)
    end
  end
end
