class AddRolesIndexToTeammates < ActiveRecord::Migration
  def up
    execute "CREATE INDEX teammates_roles ON teammates USING GIN (roles)"
  end

  def down
    execute "DROP INDEX teammates_roles"
  end
end
