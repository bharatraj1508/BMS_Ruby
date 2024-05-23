class AccountsController < ApplicationController

    def new
        @account = Account.new
    end

    def create
        @account = current_user.owned_accounts.new(account_params)
        @account.account_users.new(user: current_user)
        if @account.save
            redirect_to home_path
        else
            render :new
        end
    end

    def switch
        account_id = params[:account_id]
        if account_id.present? && current_user.accounts.exists?(account_id)
            session[:account_id] = account_id
            redirect_to home_path, notice: "Switched to #{Account.find(account_id).name}"
        else
            redirect_to home_path
        end
    end

    private

    def account_params
        params.require(:account).permit(:name)
    end

end
