class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.text       :description,     null: false
      t.integer    :points,          null: false
      t.integer    :row_order,       null: false
      t.references :tech_lead,       index: true
      t.references :product_manager, index: true
      t.string     :business_driver
      t.string     :spec_link
      t.timestamps
    end
  end
end
