require 'spec_helper'

describe Task do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:task)).to be_valid
    end

    it "is not valid without a description" do
      sprint = build(:task, description: nil)
      expect(sprint).to have(1).error_on(:description)
    end

    it "is not valid without a number of hours" do
      sprint = build(:task, hours: nil)
      expect(sprint).to have(1).error_on(:hours)
    end

    it "is not valid without a status" do
      sprint = build(:task, status: nil)
      expect(sprint).to have(1).error_on(:status)
    end

    it "is not valid with an invalid status" do
      sprint = build(:task, status: "not_supported")
      expect(sprint).to have(1).error_on(:status)
      %w[todo in_progress done].each do |value|
        sprint.status = value
        expect(sprint).to be_valid
      end
    end
  end

  context "associations" do
    it "must belong to a taskable story" do
      task = build(:task, taskable_story: taskable_story = create(:taskable_story))
      expect(task.taskable_story).to eq(taskable_story)
      task.taskable_story = nil
      expect(task).to have(1).error_on(:taskable_story)
    end

    it "must belong to a team" do
      task = build(:task, team: team = create(:team))
      expect(task.team).to eq(team)
      task.team = nil
      expect(task).to have(1).error_on(:team)
    end
  end

  context "querying" do
    context "ranking" do
      let(:team)            { create(:team, name: "team") }
      let(:taskable_story1) { create(:taskable_story, team: team) }
      let(:taskable_story2) { create(:taskable_story, team: team) }
      let(:task1)           { create(:task, taskable_story: taskable_story1, team: team) }
      let(:task2)           { create(:task, taskable_story: taskable_story2, team: team) }
      let(:task3)           { create(:task, taskable_story: taskable_story1, row_order_position: :first, team: team) }

      it "can query tasks for a taskable story in order" do
        tasks = taskable_story1.tasks.ranked
        expect(tasks).to eq([task3, task1])
      end
    end
  end
end
