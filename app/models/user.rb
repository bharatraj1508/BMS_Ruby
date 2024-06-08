class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_person_name
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :account_users
  has_many :accounts, through: :account_users

  has_many :owned_accounts, class_name: "Account", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
  has_many :account_invitations, foreign_key: :invited_by_id, class_name: "AccountInvitation", inverse_of: :invited_by

  attribute :company_name
end
