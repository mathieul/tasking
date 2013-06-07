require 'spec_helper'

describe TaskTable do
  let(:sprint) { create(:sprint, stories_count: 2) }
  let(:table)  { TaskTable.new(sprint) }

  it "should return 1 with #col_count(kind) if there's no kind tasks" do
    expect(table.col_count("todo")).to eq(1)
    expect(table.col_count("in_progress")).to eq(1)
    expect(table.col_count("done")).to eq(1)
  end

  it "should return the number of columns per kind with #col_count" do
    story1, story2 = sprint.taskable_stories
    2.times { create(:task, status: "todo",        taskable_story: story1) }
    4.times { create(:task, status: "in_progress", taskable_story: story1) }
    2.times { create(:task, status: "done",        taskable_story: story1) }
    1.times { create(:task, status: "todo",        taskable_story: story2) }
    7.times { create(:task, status: "in_progress", taskable_story: story2) }
    3.times { create(:task, status: "done",        taskable_story: story2) }

    expect(table.col_count("todo")).to eq(2 + 1)
    expect(table.col_count("in_progress")).to eq(7 + 1)
    expect(table.col_count("done")).to eq(3 + 1)
  end
end
