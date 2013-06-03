class RemoveSprintIdFromStories < ActiveRecord::Migration
  def change
    remove_reference :stories, :sprint, index: true
  end
end
