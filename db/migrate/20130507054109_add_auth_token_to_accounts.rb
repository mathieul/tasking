class AddAuthTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :auth_token, :string
    add_index :accounts, :auth_token, unique: true
  end
end
