class AddInitialsToTeammates < ActiveRecord::Migration
  def change
    add_column :teammates, :initials, :string, null: false
  end
end
