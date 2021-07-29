class AccountsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_profile, only: [:update]

    def update
        @profile = current_user.prepare_profile
        @profile.assign_attributes(profile_params)
        if @profile.save
            render json: avatar, notice: 'プロフィールを更新しました'
        else
            flash.now[:error] = '更新できませんでした'
            render :show
        end
    end

    private
    def profile_params #以下の内容だけ保存を許可
        params.require(:profile).permit(:avatar)
    end
end
