# A word of caution: It's easy to overdo a global singleton like Current and tangle your model as a result.
# Current should only be used for a few, top-level globals, like account, user, and request details.
# The attributes stuck in Current should be used by more or less all actions on all requests.
# If you start sticking controller-specific attributes in there, you're going to create a mess.

class Current < ActiveSupport::CurrentAttributes
    attribute :session
    attribute :account
    attribute :user_agent, :ip_address, :request_id

    delegate :user, to: :session, allow_nil: true

    resets do
        Time.zone = nil
        @account_user = nil
    end

    def session=(session)
        super
    end
end