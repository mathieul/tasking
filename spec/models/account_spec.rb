require 'spec_helper'

describe Account do
  it "is not valid without an email" do
    account = build(:account, email: nil)
    account.valid?
    expect(account).to have(1).error_on(:email)
  end
end
