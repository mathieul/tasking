require 'spec_helper'

describe TaskableStory do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:taskable_story)).to be_valid
    end

    it "is not valid without a status" do
      sprint = build(:taskable_story, status: nil)
      expect(sprint).to have(1).error_on(:status)
    end

    it "is not valid without a row order" do
      sprint = build(:taskable_story, row_order: nil)
      expect(sprint).to have(1).error_on(:row_order)
    end
  end

  context "associations" do
    it "must belong to a story" do
      taskable_story = build(:taskable_story, story: story = create(:story))
      expect(taskable_story.story).to eq(story)
      taskable_story.story = nil
      expect(taskable_story).to have(1).error_on(:story)
    end

    it "must belong to a sprint" do
      taskable_story = build(:taskable_story, sprint: sprint = create(:sprint))
      expect(taskable_story.sprint).to eq(sprint)
      taskable_story.sprint = nil
      expect(taskable_story).to have(1).error_on(:sprint)
    end

    it "must belong to a team" do
      taskable_story = build(:taskable_story, team: team = create(:team))
      expect(taskable_story.team).to eq(team)
      taskable_story.team = nil
      expect(taskable_story).to have(1).error_on(:team)
    end

    it "can have many tasks" do
      taskable_story = build(:taskable_story, team: team = create(:team))
      taskable_story.tasks << create(:task, team: team)
      expect(taskable_story).to be_valid
    end
  end
end
