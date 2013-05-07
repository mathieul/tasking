class AddPasswordResetToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :password_reset_token, :string
    add_column :accounts, :password_reset_sent_at, :datetime
    add_index :accounts, :password_reset_token, unique: true
  end
end
