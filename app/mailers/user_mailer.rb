class UserMailer < ApplicationMailer
    def invitation_instructions(account_invitation_id)
        @account_invitation = AccountInvitation.find(account_invitation_id)
        @invitee_name = @account_invitation.email
        @invitor_name = @account_invitation.invited_by.name
        @account_name = @account_invitation.account.name
        # This signed_id is the token...
        @signed_id = @account_invitation.signed_id(expires_in: AccountInvitation.expires_in_days(@account_invitation.expired_at))

        # Create url according to the user existence
        @have_account = User.exists?(email: @account_invitation.email)
        @have_account ? @url = accept_invitation_url(@signed_id) : @url = setup_profile_url(@signed_id)
    
        mail to: @account_invitation.email, subject: "Invitation instructions"
    end
end
