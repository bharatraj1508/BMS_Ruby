class AccountInvitation < ApplicationRecord
    has_person_name

    # Associations
    multi_tenant :account
    belongs_to :account
    belongs_to :invited_by, class_name: "User", optional: true

    # Validations
    # validates :name, presence: true
    validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
    validate :only_one_pending_invitation_per_email, on: :create

    normalizes :email, with: -> { _1.strip.downcase }

    def invite_valid?
        return false if accepted_at || declined_at
        return false if expired?
        true
    end
    
    def expired?
        expired_at.present? && Time.current > expired_at
    end
    
    def self.expires_in_days(expired_at)
        start_date = DateTime.current.jd
        end_date = expired_at.to_datetime.jd
        (end_date - start_date).days
    end
    
    def prepare_for_creation(account, account_user)
        self.account_id = account.id
        self.invited_by = account_user.user
        self.sent_at = Time.current
    end
    
    private

    def only_one_pending_invitation_per_email
        existing_invitation = AccountInvitation.where(email: email)
            .where("accepted_at IS NULL AND declined_at IS NULL")
            .where.not(id: id)
            .where("expired_at IS NULL OR expired_at > ?", Time.current)
            .exists?

        errors.add(:email, "already has a pending invitation") if existing_invitation
    end
end
