class AddColumnsToAccountUser < ActiveRecord::Migration[7.1]
  def change
    add_column :account_users, :roles, :string, array: true, default: []
    add_column :account_users, :archive, :boolean
  end
end
