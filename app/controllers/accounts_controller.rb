class AccountsController < ApplicationController
    def show
        @user = User.find(params[:id])
        @post_count = @user.post_count(@user)
        @follower_count = @user.follower_count(@user)
        @following_count = @user.following_count(@user)

        if @user == current_user
            redirect_to profile_path
        end
    end
end
