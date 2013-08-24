require 'spec_helper'

describe TeammateForm do
  context "validation" do
    it "is valid with valid attributes" do
      form = TeammateForm.new(valid_attributes)
      expect(form).to be_valid
    end

    it "is not valid without a name" do
      form = TeammateForm.new(valid_attributes.merge(name: nil))
      expect(form).to have(1).error_on(:name)
    end

    it "is not valid without a color" do
      form = TeammateForm.new(valid_attributes.merge(color: nil))
      expect(form).to have(1).error_on(:color)
    end
  end

  context "instantiation" do
    let(:teammate) { build(:teammate) }

    it "can be created from a teammate" do
      form = TeammateForm.from_teammate(teammate)
      expect(form.name).to eq(teammate.name)
      expect(form.email).to be_nil
    end

    it "can be created from a teammate with an account" do
      teammate.account = build(:account, email: "john@doe.com")
      form = TeammateForm.from_teammate(teammate)
      expect(form.email).to eq("john@doe.com")
    end

    it "knows the teammate id" do
      teammate.save!
      form = TeammateForm.from_teammate(teammate)
      expect(form.teammate_id).to eq(teammate.id)
    end
  end

  context "persistence" do
    let(:team) { create(:team) }

    it "returns true if the form is valid" do
      form = TeammateForm.new(name: "toto", color: "red")
      expect(form.submit(scope: team)).to be_true
    end

    it "returns false if the form isn't valid" do
      form = TeammateForm.new(name: "toto")
      expect(form.submit(scope: team)).to be_false
    end

    it "creates a new teammate if teammate doesn't exist" do
      form = TeammateForm.new(name: "toto", color: "baby-blue")
      form.submit(scope: team)
      expect(form.teammate).to be_valid
      expect(form.teammate.color).to eq("baby-blue")
      expect(form.teammate.team).to eq(team)
    end

    it "updates an existing teammate if teammate already exists" do
      teammate = create(:teammate, name: "jojo", team: team)
      form = TeammateForm.new(teammate_id: teammate.id, name: "titi", color: "baby-blue")
      expect { form.submit(scope: team) }.not_to change { Teammate.count }
      teammate.reload
      expect(teammate.name).to eq("titi")
    end

    it "is persited if it has a teammate id" do
      expect(TeammateForm.new).not_to be_persisted
      expect(TeammateForm.new(teammate_id: 12)).to be_persisted
    end

    context "if email is set" do
      it "creates an account if it doesn't exist" do
        form = TeammateForm.new(name: "jim", color: "black", email: "jim@black.com")
        form.submit(scope: team)
        expect(form.teammate.account).to be_valid
        expect(form.teammate.account.email).to eq("jim@black.com")
      end

      it "associates an existing account if not associated yet" do
        account = create(:account, email: "blah@foo.com", team: team)
        form = TeammateForm.new(name: "blah", color: "black", email: "blah@foo.com")
        form.submit(scope: team)
        expect(form.teammate.account).to be_valid
        expect(form.teammate.account.id).to eq(account.id)
      end

      it "returns an error if account exists and is already associated" do
        account = create(:account, email: "blah@foo.com", team: team)
        create(:teammate, account: account, team: team)
        form = TeammateForm.new(name: "blah", color: "black", email: "blah@foo.com")
        expect(form.submit(scope: team)).to be_false
        expect(form.errors[:base].length).to eq(1)
      end

      it "returns an error if account exists for another team" do
        create(:account, email: "blah@foo.com")
        form = TeammateForm.new(name: "blah", color: "black", email: "blah@foo.com")
        expect(form.submit(scope: team)).to be_false
        expect(form.errors[:base].length).to eq(1)
      end
    end
  end

  context "routing" do
    it "returns the teammate create path with #path if not persisted" do
      expect(TeammateForm.new.path).to eq("/teammates")
    end

    it "returns the teammate update path with #path if persisted" do
      teammate = create(:teammate)
      expect(TeammateForm.new(teammate_id: teammate.id).path).to eq("/teammates/#{teammate.id}")
    end
  end

  private

  def valid_attributes
    {name: "Blah", color: "yellow"}
  end
end
