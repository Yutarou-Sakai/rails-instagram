class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception #CSRF対策
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user!

    protected

    def configure_permitted_parameters # usernameとpasswordでログインできるようにする
        added_attrs = [ :email, :username, :password, :password_confirmation ] #許可する情報
        devise_parameter_sanitizer.permit :sign_up, keys: added_attrs #sign upで許可
        devise_parameter_sanitizer.permit :account_update, keys: added_attrs #updateで許可
        devise_parameter_sanitizer.permit :sign_in, keys: added_attrs #sign inで許可
    end

    def after_sign_in_path_for(resource) 
        root_path
    end
end
