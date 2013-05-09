class AddActivationToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :activation_token, :string
    add_column :accounts, :activated_at, :datetime
    add_index  :accounts, :activation_token, unique: true
  end
end
