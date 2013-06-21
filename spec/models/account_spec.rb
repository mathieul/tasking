require 'spec_helper'

describe Account do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:account)).to be_valid
    end

    it "is valid without a password if persisted already" do
      account = create(:account)
      account = Account.find(account.id)
      expect(account.password).to be_nil
      expect(account).to be_valid
    end

    it "is not valid without an email" do
      account = build(:account, email: nil)
      expect(account).to have(1).error_on(:email)
    end

    it "is not valid without a unique email" do
      create(:account, email: "onlyyou@example.com")
      account = build(:account, email: "onlyyou@example.com")
      expect(account).to have(1).error_on(:email)
    end

    it "is not valid with an invalid password" do
      account = build(:account, password: "12345")
      expect(account).to have(1).error_on(:password)
      account.password = account.password_confirmation = "123456"
      expect(account).to be_valid
    end
  end

  context "associations" do
    it "must belong to a team" do
      account = build(:account, team: team = create(:team))
      expect(account.team).to eq(team)
      expect(account).to be_valid
      account.team = nil
      expect(account).not_to be_valid
    end

    it "has one teammate" do
      teammate = create(:teammate, team: create(:team))
      account = build(:account, teammate: teammate)
      expect(account.teammate).to eq(teammate)
    end
  end

  context "tokens" do
    let(:account) { create(:account) }

    it "is created with an authentication token" do
      expect(account.auth_token).to be_a(String)
    end

    it "is created with an activation token" do
      expect(account.activation_token).to be_a(String)
    end
  end

  context "activation" do
    it "can be activated with #activate!" do
      account = create(:account)
      expect(account).not_to be_activated
      account.activate!
      expect(account).to be_activated
    end
  end
end
