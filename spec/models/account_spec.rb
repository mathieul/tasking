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
      account.valid?
      expect(account).to have(1).error_on(:email)
    end

    it "is not valid without a unique email" do
      create(:account, email: "onlyyou@example.com")
      account = build(:account, email: "onlyyou@example.com")
      account.valid?
      expect(account).to have(1).error_on(:email)
    end

    it "is not valid with an invalid password" do
      account = build(:account, password: "12345")
      account.valid?
      expect(account).to have(1).error_on(:password)
      account.password = "123456"
      expect(account).to be_valid
    end
  end

  context "tokens" do
    it "it is created with an authentication token" do
      account = create(:account)
      expect(account.auth_token).to be_a(String)
    end
  end
end
