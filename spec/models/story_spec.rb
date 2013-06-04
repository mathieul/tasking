require 'spec_helper'
require 'set'

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

    it "is not valid without a valid points value" do
      story = build(:story, points: nil)
      expect(story).not_to be_valid
      [-1, 6, 22, 50].each do |value|
        story.points = value
        expect(story).not_to be_valid
      end
      story.points = 3
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

    it "can have a row order" do
      story = build(:story, row_order: 7)
      expect(story.row_order).to eq(7)
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

  context "associations" do
    it "must belong to a team" do
      story = build(:story, team: team = create(:team))
      expect(story.team).to eq(team)
      expect(story).to be_valid
      story.team = nil
      expect(story).not_to be_valid
    end

    it "has many taskable stories" do
      sprint = create(:sprint)
      story = create(:story)
      story.taskable_stories << build(:taskable_story, sprint: sprint)
      expect(story).to be_valid
    end
  end

  context "querying" do
    context "ranking" do
      let(:team1)   { create(:team, name: "team1") }
      let(:team2)   { create(:team, name: "team2") }
      let(:sprint1) { create(:sprint, team: team1, stories_count: 0, stories: [t1s1sp1, t1s2sp1]) }
      let!(:t1s2p)  { create(:story, team: team1) }
      let!(:t1s1p)  { create(:story, team: team1, row_order_position: :first) }
      let!(:t2s2p)  { create(:story, team: team2) }
      let!(:t2s1p)  { create(:story, team: team2, row_order_position: :first) }
      let(:t1s2sp1) { create(:story, team: team1) }
      let(:t1s1sp1) { create(:story, team: team1) }

      it "can query stories of a team in order" do
        stories = team1.stories.ranked
        expect(stories).to eq([t1s1p, t1s2p])
      end
    end
  end
end
