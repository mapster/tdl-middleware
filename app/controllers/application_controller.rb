class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    skip_before_filter :verify_authenticity_token

    private
    def current_user_session
        @current_user_session ||= UserSession.find
    end
    
    def current_user
        @current_user ||= current_user_session && current_user_session.user
    end

    def authorize_by_authentication
        if current_user.nil?
            render nothing: true, status: :forbidden
        end
    end

    def authorized? (action)
        return false if current_user.nil?
        auth = current_user.user_authorization
        return false if auth.nil?

        raise SecurityError, "No such authorizable action: #{action}" unless auth.respond_to? 'manage_exercises'

        auth.public_send action
    end
end
