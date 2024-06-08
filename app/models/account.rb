class Account < ApplicationRecord
    belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
    has_many :account_users
    has_many :users, through: :account_users
    has_many :account_invitation
end
