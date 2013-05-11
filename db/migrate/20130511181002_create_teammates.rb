class CreateTeammates < ActiveRecord::Migration
  def change
    create_table :teammates do |t|
      t.string     :name,    null: false
      t.references :account, index: true
      t.timestamps
    end
  end
end
