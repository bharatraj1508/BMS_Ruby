class UserPolicy < ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
        raise Pundit::NotAuthorizedError, "must be logged in" unless user
        @user = user
        @record = record
    end

    private

    def owner
        return true if user.id == record.account.owner_id
    end
end
