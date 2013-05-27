class AddSprintIdToStories < ActiveRecord::Migration
  def change
    add_reference :stories, :sprint, index: true
  end
end
