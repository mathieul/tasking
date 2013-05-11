class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string     :description,     null: false
      t.integer    :points,          null: false
      t.decimal    :sort,            precision: 5, scale: 2
      t.references :tech_lead,       index: true
      t.references :product_manager, index: true
      t.string     :business_driver
      t.string     :spec_link
      t.timestamps
    end
  end
end
