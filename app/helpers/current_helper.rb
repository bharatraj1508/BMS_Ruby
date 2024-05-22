module CurrentHelper
    def current_account
        Current.account
    end

    def current_account_user
        @account_user ||= current_account.account_users.find_by(user: current_user)
    end
end