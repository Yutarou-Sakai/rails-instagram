class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post

    def create
        post.likes.create!(user_id: current_user.id)

        render json: { status: 'ok' }
    end

    def destroy
        like =  post.likes.find_by!(user_id: current_user.id)
        like.destroy!

        render json: { status: 'ok' }
    end

    private
    def set_post
        post = Post.find(params[:post_id])
    end
end
