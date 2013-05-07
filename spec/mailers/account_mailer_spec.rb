require "spec_helper"

describe AccountMailer do
  describe "password_reset" do
    let(:account) { create(:account, email: "to@example.org").generate_token(:password_reset_token) }
    let(:mail)    { AccountMailer.password_reset(account) }

    it "renders the headers" do
      mail.subject.should eq("Password reset")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("http://example.com/password_resets/#{account.password_reset_token}/edit")
    end
  end

end
