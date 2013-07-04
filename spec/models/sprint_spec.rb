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

  context "other attributes" do
    it "can have a measured velocity" do
      sprint = build(:sprint, measured_velocity: 42)
      expect(sprint.measured_velocity).to eq(42)
    end

    it "has a sprint number per team" do
      team1, team2 = create(:team), create(:team)
      sprint1t1 = create(:sprint, team: team1)
      sprint1t2 = create(:sprint, team: team2)
      expect(team1.sprints.create).not_to be_valid
      sprint2t2 = create(:sprint, team: team2)
      sprint2t1 = create(:sprint, team: team1)
      expect([sprint1t1.number, sprint2t1.number]).to eq([1, 2])
      expect([sprint1t2.number, sprint2t2.number]).to eq([1, 2])
    end

    it "doesn't change the sprint number if it is already set" do
      sprint = create(:sprint, number: 12)
      expect(sprint.number).to eq(12)
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

    it "can have many taskable stories" do
      sprint = create(:sprint, stories_count: 0)
      taskable_story = create(:taskable_story, sprint: sprint)
      expect(sprint.reload.taskable_stories).to eq([taskable_story])
    end

    it "can create taskable stories using #story_ids=" do
      story = create(:story, team: team)
      sprint = create(:sprint, stories_count: 0, story_ids: [story.id], team: team)
      expect(sprint.taskable_stories.map(&:story)).to eq([story])
    end

    it "preserves the order or stories in taskable stories" do
      stories = [
        create(:story, row_order: 5, team: team),
        create(:story, row_order: 1, team: team),
        create(:story, row_order: 9, team: team)
      ]
      sprint = create(:sprint, stories_count: 0, story_ids: stories.map(&:id), team: team)
      expect(sprint.taskable_stories.map(&:story)).to eq(stories.sort_by(&:row_order))
    end

    it "has many stories through taskable stories" do
      sprint = create(:sprint, stories_count: 0)
      story = create(:story)
      taskable_story = create(:taskable_story, sprint: sprint, story: story)
      expect(sprint.stories).to eq([story])
    end

    it "sets the owner to taskable stories when there's an ovbious one" do
      tech_lead = create(:teammate, roles: %w[tech_lead engineer])
      pm = create(:teammate, roles: %w[product_manager engineer])
      stories = [
        with_tech = create(:story, tech_lead: tech_lead, product_manager: nil, team: team),
        with_pm   = create(:story, tech_lead: nil, product_manager: pm, team: team),
        with_both = create(:story, tech_lead: tech_lead, product_manager: pm, team: team),
        with_none = create(:story, tech_lead: nil, product_manager: nil, team: team)
      ]
      sprint = create(:sprint, stories_count: 0, story_ids: stories.map(&:id), team: team)
      expect(sprint.taskable_stories.where(story_id: with_tech.id).take.owner).to eq(tech_lead)
      expect(sprint.taskable_stories.where(story_id: with_pm.id).take.owner).to eq(pm)
      expect(sprint.taskable_stories.where(story_id: with_both.id).take.owner).to eq(tech_lead)
      expect(sprint.taskable_stories.where(story_id: with_none.id).take.owner).to be_nil
    end
  end

  context "querying" do
    context ".find_from_kind_or_id" do
      let!(:old_sprint)     { create(:sprint, start_on: 3.months.ago,     end_on: 2.months.ago) }
      let!(:last_sprint)    { create(:sprint, start_on: 3.weeks.ago,      end_on: 1.week.ago)}
      let!(:current_sprint) { create(:sprint, start_on: 6.days.ago,       end_on: 6.days.from_now)}
      let!(:next_sprint)    { create(:sprint, start_on: 1.week.from_now,  end_on: 3.weeks.from_now)}
      let!(:future_sprint)  { create(:sprint, start_on: 1.month.from_now, end_on: 2.months.from_now)}

      it "finds the last sprint with :last" do
        expect(Sprint.find_from_kind_or_id(:last)).to eq(last_sprint)
      end

      it "finds the current sprint with :current" do
        expect(Sprint.find_from_kind_or_id(:current)).to eq(current_sprint)
      end

      it "finds the next sprint with :next" do
        expect(Sprint.find_from_kind_or_id(:next)).to eq(next_sprint)
      end

      it "finds the sprint by id if none of :last, :current or :next" do
        expect(Sprint.find_from_kind_or_id(future_sprint.id)).to eq(future_sprint)
      end

      it "returns nil if none is found" do
        current_sprint.destroy
        expect(Sprint.find_from_kind_or_id(:current)).to be_nil
      end
    end
  end
end
