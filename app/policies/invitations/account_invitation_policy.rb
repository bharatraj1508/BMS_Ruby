module Invitations
    class AccountInvitationPolicy < UserPolicy

        def create?
            owner
        end

        def new?
            owner
        end
    end
end

