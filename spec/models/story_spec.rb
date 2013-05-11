require 'spec_helper'

describe Story do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:story)).to be_valid
    end

    it "is not valid without a description" do
      story = build(:story, description: nil)
      expect(story).not_to be_valid
      story.description = "blah blah blah"
      expect(story).to be_valid
    end

    it "is not valid without a points value" do
      story = build(:story, points: nil)
      expect(story).not_to be_valid
      story.points = 3
      expect(story).to be_valid
    end

    it "is not valid without a row order" do
      story = build(:story, row_order: nil)
      expect(story).not_to be_valid
      story.row_order = 3
      expect(story).to be_valid
    end

    it "is not valid if the row order is not an integer number" do
      story = build(:story, row_order: "blah")
      expect(story).not_to be_valid
      story.row_order = 12
      expect(story).to be_valid
    end
  end

  context "optional attributes" do
    it "can have a tech lead" do
      story = build(:story, tech_lead: teammate = create(:teammate))
      expect(story.tech_lead).to eq(teammate)
    end

    it "can have a product manager" do
      story = build(:story, product_manager: product_manager = create(:teammate))
      expect(story.product_manager).to eq(product_manager)
    end

    it "can have a business driver" do
      story = build(:story, business_driver: "generate money")
      expect(story.business_driver).to eq("generate money")
    end

    it "can have a link to a spec" do
      story = build(:story, spec_link: "www.google.com")
      expect(story.spec_link).to eq("www.google.com")
    end
  end
end
