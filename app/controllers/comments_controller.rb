class CommentsController < ApplicationController
    before_action :set_post, only: [:index, :create]
    before_action :set_comments, only: [:index, :create]


    def index
        render json: @comments, include: { user: [:profile] }
    end

    def create
        @comment = @post.comments.build(comment_params)
        @comment.save

        render json: @comment, include: { user: [:profile] }
    end

    def destroy
        
    end

    private
    def comment_params
        params.require(:comment).permit(:content).merge(user_id: current_user.id)
    end

    def set_post
        @post = Post.find(params[:post_id])
    end

    def set_comments
        @comments = Comment.where(post_id: @post.id)
    end
end
