require 'spec_helper'

describe TaskDecorator do
  let(:task)      { double }
  let(:decorator) { TaskDecorator.decorate(task) }

  it "returns description and duration with #timed_description" do
    task.stub(description: "the thing to do", hours: 0)
    expect(decorator.timed_description).to eq("the thing to do")
    task.stub(hours: 12)
    expect(decorator.timed_description).to eq("the thing to do 12h")
  end
end
