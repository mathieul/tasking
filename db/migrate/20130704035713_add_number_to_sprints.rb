class AddNumberToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :number, :integer, null: false
    add_index :sprints, [:team_id, :number], unique: true
  end
end
