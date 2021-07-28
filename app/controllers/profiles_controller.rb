class ProfilesController < ApplicationController

    def show
        @profile = current_user.profile #user.rb に has_one :profile とあるので .profile が使える
    end
end
