class ApplicationController < ActionController::Base
    
    include Pundit::Authorization
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    
    protect_from_forgery with: :exception

    include CurrentHelper
    include SetCurrentRequestDetails
    
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def user_not_authorized(exception)
        policy_name = exception.policy.class.to_s.underscore
    
        flash[:alert] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
        redirect_back(fallback_location: home_path)
    end

    def configure_permitted_parameters
        extra_keys = [:first_name, :last_name, :time_zone, :email, :password, :company_name]
        devise_parameter_sanitizer.permit(:sign_up, keys: extra_keys)
    end

    def after_sign_in_path_for(resource_or_scope)
        session[:account_id] = resource&.accounts&.first&.id || resource_or_scope&.accounts&.first&.id
        stored_location_for(resource_or_scope) || super
        home_path
    end

    def after_sign_out_path_for(resource_or_scope)
        new_user_session_path
    end


    def after_inactive_sign_up_path_for(resource)
        new_user_session_path
    end

end
