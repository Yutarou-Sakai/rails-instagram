class AccountsController < ApplicationController
    before_action :authenticate_user! #ログインしている人限定
    before_action :set_profile, only: [:edit, :update]

    def update
        @profile.assign_attributes(profile_params)
        if @profile.save
            render json: url_for(@profile.avatar)
        else
            render json: user.errors, status: :bad_request
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
