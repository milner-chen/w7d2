class UsersController < ApplicationController
    def create
        @user = User.new(user_params)
        if @user.save
            session[:session_token] = @user.session_token # login user
            flash[:messages] = ["user created successfully"]
            redirect_to user_url(@user)
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    def new
        # @user = User.new # views shit
        render :new
    end

    def show
        @user = User.find(params[:id])
        render :show
    end

    private
    def user_params
        params.require(:user).permit(:email, :password)
    end
end