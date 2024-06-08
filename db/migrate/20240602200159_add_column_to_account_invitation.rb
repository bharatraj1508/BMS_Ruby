class AddColumnToAccountInvitation < ActiveRecord::Migration[7.1]
  def change
    add_column :account_invitations, :roles, :string, array: true, default: []
  end
end
