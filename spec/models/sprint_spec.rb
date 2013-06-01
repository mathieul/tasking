require 'spec_helper'

describe Sprint do
  context "validation" do
    it "is valid with valid attributes" do
      expect(build(:sprint)).to be_valid
    end

    it "is not valid without a projected velocity" do
      sprint = build(:sprint, projected_velocity: nil)
      expect(sprint).to have(1).error_on(:projected_velocity)
    end

    it "is not valid if the projected velocity is not a strict integer" do
      sprint = build(:sprint, projected_velocity: "blah")
      expect(sprint).to have(1).error_on(:projected_velocity)
      sprint.projected_velocity = 0
      expect(sprint).to have(1).error_on(:projected_velocity)
    end

    it "is not valid without a status" do
      sprint = build(:sprint, status: nil)
      expect(sprint).to have(1).error_on(:status)
    end

    it "is not valid if the status is not supported" do
      sprint = build(:sprint, status: "blah")
      expect(sprint).to have(1).error_on(:status)
      %w[draft planned in_progress canceled completed].each do |status|
        sprint.status = status
        expect(sprint).to be_valid
      end
    end

    it "is not valid without a start date" do
      sprint = build(:sprint, start_on: nil)
      expect(sprint).to have(1).error_on(:start_on)
    end

    it "is not valid without an end date" do
      sprint = build(:sprint, end_on: nil)
      expect(sprint).to have(1).error_on(:end_on)
    end
  end

  context "optional attributes" do
    it "can have a measured velocity" do
      sprint = build(:sprint, measured_velocity: 42)
      expect(sprint.measured_velocity).to eq(42)
    end
  end

  context "associations" do
    let(:team) { create(:team) }

    it "must belong to a team" do
      sprint = build(:sprint, team: team)
      expect(sprint.team).to eq(team)
      expect(sprint).to be_valid
      sprint.team = nil
      expect(sprint).not_to be_valid
    end

    it "must have many stories" do
      sprint = build(:sprint, stories_count: 0, team: team)
      expect(sprint).not_to be_valid
      sprint.stories << create(:story, team: team)
      expect(sprint).to be_valid
    end

    it "can assign backlog stories using #story_ids=" do
      story = create(:story, team: team)
      sprint = create(:sprint, stories_count: 0, team: team, story_ids: [story.id])
      expect(sprint.stories).to eq([story])
    end

    it "can't assign stories already assigned with #story_ids" do
      previous = create(:sprint, team: team)
      story = previous.stories.first
      sprint = build(:sprint, stories_count: 0, team: team, story_ids: [story.id])
      expect(sprint).not_to be_valid
    end
  end
end
