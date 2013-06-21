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

    it "can belong to a teammate" do
      task = build(:task, teammate: teammate = create(:teammate))
      expect(task.teammate).to eq(teammate)
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

  context "manipulation" do
    let(:taskable_story) { create(:taskable_story) }
    let!(:task_todo1)    { create(:task, status: "todo", hours: 2, taskable_story: taskable_story, row_order_position: :last) }
    let!(:task_todo2)    { create(:task, status: "todo", hours: 4, taskable_story: taskable_story, row_order_position: :last) }
    let!(:task_prog1)    { create(:task, status: "in_progress", hours: 1, taskable_story: taskable_story, row_order_position: :last) }
    let!(:task_prog2)    { create(:task, status: "in_progress", hours: 5, taskable_story: taskable_story, row_order_position: :last) }
    let!(:task_done)     { create(:task, status: "done", hours: 0, taskable_story: taskable_story, row_order_position: :last) }

    it "progresses the task with #progress!" do
      task_todo2.progress!
      expect(task_todo2.status).to eq("in_progress")
      expect(task_todo2.hours).to eq(4)
      expect(taskable_story.tasks).to eq([task_todo1, task_prog1, task_prog2, task_todo2, task_done])
    end

    it "completes the task with #complete!" do
      task_prog1.complete!
      expect(task_prog1.status).to eq("done")
      expect(task_prog1.hours).to eq(0)
      expect(taskable_story.tasks).to eq([task_todo1, task_todo2, task_prog2, task_done, task_prog1])
    end
  end
end
