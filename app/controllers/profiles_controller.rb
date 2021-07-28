class ProfilesController < ApplicationController
    before_action :authenticate_user! #ログインしている人限定
    before_action :set_profile, only: [:edit, :update]

    def show
        @profile = current_user.profile #user.rb に has_one :profile とあるので .profile が使える
    end

    def edit
    end

    def update
        @profile.assign_attributes(profile_params) #@profileに対してパラメータの値を合体できる
        if @profile.save
            redirect_to profile_path, notice: 'プロフィールを更新しました'
        else
            flash.now[:error] = '更新できませんでした'
            render :edit
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
