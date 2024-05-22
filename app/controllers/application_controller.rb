class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    include CurrentHelper
    include SetCurrentRequestDetails
    
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        extra_keys = [:first_name, :last_name, :time_zone, :email, :password, :company_name]
        devise_parameter_sanitizer.permit(:sign_up, keys: extra_keys)
    end

    def after_sign_in_path_for(resource_or_scope)
        session[:account_id] = resource&.accounts&.first&.id || resource_or_scope&.accounts&.first&.id
        stored_location_for(resource_or_scope) || super
    end

    def after_sign_out_path_for(resource_or_scope)
        new_user_session_path
    end


    def after_inactive_sign_up_path_for(resource)
        new_user_session_path
    end

end
