module SetCurrentRequestDetails
    extend ActiveSupport::Concern

    included do
        set_current_tenant_through_filter
        before_action :set_request_details
    end

    def set_request_details
        Current.user_agent = request.user_agent
        Current.ip_address = request.ip
        Current.request_id = request.uuid

        set_current_account
    end

    def set_current_account
        Current.account = Account.find_by(id: session[:account_id]) || fallback_account
        set_current_tenant(Current.account)
    end

    def fallback_account
        return unless user_signed_in?
        current_user.accounts.order(created_at: :asc).first
    end
end