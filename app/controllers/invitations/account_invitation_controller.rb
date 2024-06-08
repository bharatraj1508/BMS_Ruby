class Invitations::AccountInvitationController < Invitations::BaseController

    skip_before_action :set_account_invitation, only: [:new, :create]
    skip_before_action :check_account_invitation_status, only: [:new, :create]

    def new
        @account_invitation = AccountInvitation.new
    end

    def create

        if already_joined?(current_account, account_invitation_params[:email])
            redirect_to account_invite_path, alert: "This email address is already a part of this account."
            return
        end

        @account_invitation = AccountInvitation.new(account_invitation_params)
        @account_invitation.prepare_for_creation(current_account, current_account_user)
        existing_invitation = AccountInvitation.find_by(email: @account_invitation.email, account_id: current_account.id)

        if AccountInvitation.expires_in_days(@account_invitation.expired_at) == 0
            flash[:alert] = "The invitation cannot be saved because it expires today. Set the expiration date more than 24 hours."
            render :new, status: :unprocessable_entity
            return
        end

        if @account_invitation.save
            UserMailer.invitation_instructions(@account_invitation.id).deliver_now
            redirect_to account_invite_path, notice: "Invitation sent to #{@account_invitation.email}"
        else
            if existing_invitation.present?
                flash[:alert] = "An invitation has already been sent to this email address."
                render :new, status: :unprocessable_entity
                return
            end
            render :new, status: :unprocessable_entity
        end
    end

    def setup_profile
        @user = User.new
    end

    def accept
        if already_joined?(@account_invitation.account, @account_invitation.email)
            if user_signed_in?
                redirect_to home_path, notice: "You have already joined #{@account_invitation.account.name}"
            else
                redirect_to new_user_session_path, notice: "You have already joined #{@account_invitation.account.name}"
            end
            return
        end
        @user = User.find_or_initialize_by(email: @account_invitation.email)
        ApplicationRecord.transaction do
            if params[:user].present?
                @user.assign_attributes(user_params)
                @user.confirmed_at = Time.current
            end

            if @user.save
                create_or_update_account_user!(@account_invitation.account, @user, @account_invitation.roles)
                @account_invitation.update(accepted_at: Time.current)
                if user_signed_in?
                    session[:account_id] = @account_invitation.account.id
                    redirect_to home_path, notice: "You have successfully joined #{@account_invitation.account.name}"
                else
                    redirect_to new_user_session_path, notice: "You have successfully joined #{@account_invitation.account.name}. Please login with your email and password."
                end
            else
                redirect_to new_user_session_path, alert: "Something went wrong"
            end
        end
    end

    def decline
        @account_invitation.update(declined_at: Time.current)
        redirect_to new_user_session_path, notice: "You have chosen not to join the organization at this time. If you wish to join in the future, please request a new invitation."
    end

    private

    def already_joined?(account, email)
        user = User.find_by(email: email)
        AccountUser.exists?(account: account, user: user)
    end

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def account_invitation_params
        params.require(:account_invitation).permit(:email, :expired_at, roles: [])
    end
end
