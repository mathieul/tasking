class AddOwnerReferenceToTaskableStories < ActiveRecord::Migration
  def change
    add_reference :taskable_stories, :owner, index: true
  end
end
