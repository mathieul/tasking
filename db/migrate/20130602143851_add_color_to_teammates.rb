class AddColorToTeammates < ActiveRecord::Migration
  def change
    add_column :teammates, :color, :string, null: false
  end
end
