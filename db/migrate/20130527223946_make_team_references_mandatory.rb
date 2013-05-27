class MakeTeamReferencesMandatory < ActiveRecord::Migration
  def up
    change_column_null :accounts,  :team_id, false
    change_column_null :stories,   :team_id, false
    change_column_null :teammates, :team_id, false
  end
end
