class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in? # these are needed in views
    
    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login!(user)
        session[:session_token] = @user.reset_session_token!
    end

    def logged_in?
        !!current_user
    end

    def logout!
        @current_user.session_token.reset_session_token! if logged_in?
        # check if user is logged in before you attempt to logout
        session[:session_token] = nil
        @current_user = nil
    end
end
