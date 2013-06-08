class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :description,        null: false
      t.integer :hours,             null: false, default: 1
      t.string :status,             null: false
      t.integer :row_order,         null: false
      t.references :taskable_story, index: true, null: false
      t.references :team,           index: true, null: false

      t.timestamps
    end
  end
end
