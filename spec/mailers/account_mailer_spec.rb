require "spec_helper"

describe AccountMailer do
  describe "password_reset" do
    let(:account) do
      create(:account, email: "to@example.org").tap do |account|
        account.generate_token(:password_reset_token)
        account.save
      end
    end
    let(:mail) { AccountMailer.password_reset(id: account.id) }

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
