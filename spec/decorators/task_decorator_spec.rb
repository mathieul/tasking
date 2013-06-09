require 'spec_helper'

describe TaskDecorator do
  let(:task)      { double }
  let(:decorator) { TaskDecorator.decorate(task) }

  it "returns the duration as an int if no decimal with #duration" do
    task.stub(hours: 12.0)
    expect(decorator.duration).to eq(12)
    task.stub(hours: 12.5)
    expect(decorator.duration).to eq(12.5)
  end

  it "returns description and duration with #timed_description" do
    task.stub(description: "the thing to do", hours: 0)
    expect(decorator.timed_description).to eq("the thing to do")
    task.stub(hours: 12.0)
    expect(decorator.timed_description).to eq("the thing to do 12h")
  end
end
