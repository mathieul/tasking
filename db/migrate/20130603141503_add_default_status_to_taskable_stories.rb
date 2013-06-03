class AddDefaultStatusToTaskableStories < ActiveRecord::Migration
  def change
    change_column_default :taskable_stories, :status, "draft"
  end
end
