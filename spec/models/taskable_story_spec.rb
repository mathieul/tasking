require 'spec_helper'

describe TaskableStory do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:taskable_story)).to be_valid
    end
  end

  context "associations" do
    it "must belong to a team" do
      taskable_story = build(:taskable_story, team: team = create(:team))
      expect(taskable_story.team).to eq(team)
      expect(taskable_story).to be_valid
      taskable_story.team = nil
      expect(taskable_story).not_to be_valid
    end
  end
end
