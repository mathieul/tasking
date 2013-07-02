require 'spec_helper'

describe StoryDecorator do
  let(:story)     { double }
  let(:decorator) { StoryDecorator.decorate(story) }

  it "wraps the number of points in a badge with #badged_points" do
    story.stub(points: 12)
    expect(decorator.badged_points).to eq('<span class="badge">12</span>')
  end

  it "wraps 0 points into an inverse badge with #badged_points" do
    story.stub(points: 0)
    expect(decorator.badged_points).to eq('<span class="badge badge-inverse">0</span>')
  end

  it "wraps 3 points into a success badge with #badged_points" do
    story.stub(points: 3)
    expect(decorator.badged_points).to eq('<span class="badge badge-success">3</span>')
  end

  it "formats spec link as a HTML link with #link_to_spec" do
    story.stub(spec_link: nil)
    expect(decorator.link_to_spec).to eq('')
    story.stub(spec_link: "http://daringfireball.net")
    expect(decorator.link_to_spec).to eq('<a href="http://daringfireball.net" target="_new">http://daringfireball.net</a>')
  end
end
