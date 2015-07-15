class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    skip_before_filter :verify_authenticity_token

    helper_method :current_user_session, :current_user

    private
    def current_user_session
        @current_user_session ||= UserSession.find
    end
    
    def current_user
        @current_user ||= current_user_session && current_user_session.user
    end

    def authenticated
        puts (not current_user.nil?)
        not current_user.nil?
    end
end
