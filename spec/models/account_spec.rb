require 'spec_helper'

describe Account do
  it "is valid with valid attributes" do
    expect(build(:account)).to be_valid
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
