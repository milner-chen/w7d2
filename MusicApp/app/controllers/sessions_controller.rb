class SessionsController < ApplicationController
    def create
        # current_user
        @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
        if @user
            # session[:session_token] = @user.reset_session_token! # login(user)
            login!(@user)
            flash[:messages] = ["Logged in"]
            redirect_to user_url(@user)
        else
            flash.now[:errors] = ["invalid creds"]
            render :new
        end

    end

    def new
        render :new
    end

    def destroy
        # logout!
        @current_user.session_token.reset_session_token! if logged_in? #
        session[:session_token] = nil #
        @current_user = nil # 

        flash[:messages] = ["Logged out"]
        redirect_to new_session_url
    end

end