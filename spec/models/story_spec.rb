require 'spec_helper'

describe Story do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:story)).to be_valid
    end

    it "can have a tech lead"

    it "can have a product manager"

    it "can have a business driver"

    it "is not valid without a sort value"

    it "is not valid without a description"

    it "it not valid without a point value"

    it "can have a link to a spec"
  end
end
