class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.integer    :projected_velocity, null: false
      t.integer    :measured_velocity
      t.string     :status, null: false, default: "draft"
      t.date       :start_on
      t.date       :end_on
      t.references :team, index: true, null: false
      t.timestamps
    end
  end
end
