require 'spec_helper'

describe TeammateDecorator do
  let(:teammate)  { double }
  let(:decorator) { TeammateDecorator.decorate(teammate) }

  it "returns role labels with #role_labels" do
    teammate.stub(roles: %w[teammate product_manager])
    expect(decorator.role_labels).to eq('<span class="label">product_manager</span> <span class="label">teammate</span>')
  end

  it "returns the account email if any with #account_email" do
    teammate.stub(account: nil)
    expect(decorator.account_email).to eq("-")
    teammate.stub(account: double(email: "foo@bar.com"))
    expect(decorator.account_email).to eq("foo@bar.com")
  end

  it "returns the show color class with #show_color_class" do
    teammate.stub(color: "blue")
    expect(decorator.show_color_class).to eq(class: "show-color-blue")
  end
end
