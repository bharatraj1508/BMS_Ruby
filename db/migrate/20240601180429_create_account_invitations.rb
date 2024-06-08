class CreateAccountInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :account_invitations do |t|
      t.bigint :account_id, null: false
      t.bigint :invited_by_id, null: false
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.datetime :sent_at
      t.datetime :accepted_at
      t.datetime :declined_at
      t.datetime :expired_at

      t.timestamps
    end

    add_index :account_invitations, :invited_by_id
    add_index :account_invitations, :account_id
  end
end
