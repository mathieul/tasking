require 'spec_helper'

describe ApplicationDecorator do
  let(:object)    { double }
  let(:decorator) { ApplicationDecorator.decorate(object) }

  it "formats #updated_at as a time tag" do
    object.stub(updated_at: Time.parse("2012-04-12 12:12:42 UTC"))
    expect(decorator.updated_at).to eq('<time datetime="2012-04-12T12:12:42Z">April 12, 2012 12:12</time>')
  end
end
