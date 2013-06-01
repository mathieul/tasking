require 'spec_helper'

describe SprintDecorator do
  let(:sprint)    { double }
  let(:decorator) { SprintDecorator.decorate(sprint) }

  it "formats a lable with #label" do
    sprint.stub(id: 42)
    expect(decorator.label).to eq("#42")
  end

  it "formats the start date with #start_on" do
    sprint.stub(start_on: Date.parse("2010-03-29"))
    expect(decorator.start_on).to eq("March 29, 2010")
  end

  it "formats the start date with #end_on" do
    sprint.stub(end_on: Date.parse("2013-04-12"))
    expect(decorator.end_on).to eq("April 12, 2013")
  end

  it "formats the status with #status" do
    sprint.stub(status: "in_progress")
    expect(decorator.status).to eq("In progress")
  end
end
