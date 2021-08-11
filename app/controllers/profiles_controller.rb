class ProfilesController < ApplicationController
    before_action :authenticate_user! #ログインしている人限定
    before_action :set_profile, only: [:edit, :update]

    def show
        @profile = current_user.profile #user.rb に has_one :profile とあるので .profile が使える

        @user = current_user
        @post_count = @user.post_count(@user)
        @follower_count = @user.follower_count(@user)
        @following_count = @user.following_count(@user)
    end

    def edit
    end

    def update
        #@profileに対してパラメータの値を合体できる
        @profile.assign_attributes(profile_params)
        if @profile.save
            redirect_to @profile, notice: 'プロフィール画像を変更しました'
        else
            flash.now[:error] = '更新できませんでした'
            render :show
        end
    end


    private
    def profile_params #以下の内容だけ保存を許可
        params.require(:profile).permit(:avatar)
    end

    def set_profile 
        @profile = current_user.prepare_profile #prepare_profile -> user.rb
    end
end
