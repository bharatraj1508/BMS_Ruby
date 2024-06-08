class Invitations::BaseController < ApplicationController

    skip_before_action :authenticate_user!
    
    prepend_before_action :set_account_invitation
    
    before_action :check_account_invitation_status

    private

    def set_account_invitation
        @account_invitation = AccountInvitation.find_signed(params[:id])
        redirect_to new_user_session_path, alert: "Invitation not found." unless @account_invitation
    end

    def check_account_invitation_status
        if @account_invitation.nil?
            redirect_to new_user_session_path, alert: "Invitation not found."
        elsif @account_invitation.expired?
            redirect_to new_user_session_path, alert: "Invitation has expired."
        elsif !@account_invitation.invite_valid?
            redirect_to new_user_session_path, alert: "Invitation is no longer valid."
        end
    end

    def create_or_update_account_user!(account, user, roles)
        account_user = AccountUser.find_or_initialize_by(account: account, user: user)
        account_user.roles = roles
        unless account_user.save
            Rails.logger.error "Failed to create or update account user for user_id: #{user.id}, account_id: #{account.id}"
        end
        account_user
    end
end
