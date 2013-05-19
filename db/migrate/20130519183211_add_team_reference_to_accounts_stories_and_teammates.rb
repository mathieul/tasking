class AddTeamReferenceToAccountsStoriesAndTeammates < ActiveRecord::Migration
  def change
    add_reference :accounts, :team, index: true
    add_reference :stories, :team, index: true
    add_reference :teammates, :team, index: true
  end
end
