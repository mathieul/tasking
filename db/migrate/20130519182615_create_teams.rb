class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :projected_velocity, default: 1

      t.timestamps
    end
  end
end
