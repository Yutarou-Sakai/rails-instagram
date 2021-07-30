class ProfilesController < ApplicationController
    before_action :authenticate_user! #ログインしている人限定
    before_action :set_profile, only: [:edit, :update]

    def show
        @profile = current_user.profile #user.rb に has_one :profile とあるので .profile が使える
    end

    def edit
    end

    def update
        # @profile.assign_attributes(profile_params) #@profileに対してパラメータの値を合体できる
        # if @profile.save!
        #     redirect_to profile_path, notice: 'プロフィールを更新しました'
        # else
        #     flash.now[:error] = '更新できませんでした'
        #     render :show
        # end

        # @profile = current_user.build_profile(profile_params)
        @profile.assign_attributes(profile_params)
        # if @profile.save
        #     render json: url_for(@profile.avatar)
        # else
        #     render json: user.errors, status: :bad_request
        # end
        respond_to do |format|
            if @profile.update(profile_params)
                format.html { redirect_to @profile }
                # format.json { render json: { avatar: @profile.avatar } }
            end
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
