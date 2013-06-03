class CreateTaskableStories < ActiveRecord::Migration
  def change
    create_table :taskable_stories do |t|
      t.string     :status,    null: false
      t.integer    :row_order, null: false
      t.references :story,     index: true, null: false
      t.references :sprint,    index: true, null: false
      t.references :team,      index: true, null: false
      t.timestamps
    end
  end
end
