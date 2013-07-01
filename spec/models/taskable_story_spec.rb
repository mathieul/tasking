require 'spec_helper'

describe TaskableStory do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:taskable_story)).to be_valid
    end

    it "is not valid without a status" do
      taskable_story = build(:taskable_story, status: nil)
      expect(taskable_story).to have(1).error_on(:status)
    end

    it "is not valid if the status is not supported" do
      taskable_story = build(:taskable_story, status: "not_supported")
      expect(taskable_story).to have(1).error_on(:status)
      %w[draft tasked completed accepted].each do |status|
        taskable_story.status = status
        expect(taskable_story).to be_valid
      end
    end

    it "is not valid without a row order" do
      taskable_story = build(:taskable_story, row_order: nil)
      expect(taskable_story).to have(1).error_on(:row_order)
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

    it "can belong to an owner" do
      taskable_story = build(:taskable_story, owner: teammate = create(:teammate))
      expect(taskable_story.owner).to eq(teammate)
    end

    it "has many tasks" do
      taskable_story = build(:taskable_story, team: team = create(:team))
      taskable_story.tasks << create(:task, team: team)
      expect(taskable_story).to be_valid
    end
  end

  context "delegation" do
    it "delegates getting and setting the description to its story" do
      taskable_story = build(:taskable_story, story: story = create(:story))
      taskable_story.description = "delegate to story"
      expect(taskable_story.description).to eq("delegate to story")
      expect(story.reload.description).to eq("delegate to story")
    end
  end
end
